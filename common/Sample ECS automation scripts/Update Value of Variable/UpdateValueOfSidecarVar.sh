#!/bin/bash
set -euo pipefail

export AWS_REGION=us-east-1
export AWS_DEFAULT_REGION=us-east-1

CLUSTER_NAME="<CLUSTER>"
export AWS_PAGER=""

echo "🔎 Replacing TOKEN_CACHE_REFRESH_PRIOR_EXPIRATION=3595 in sidecars for all services in $CLUSTER_NAME ..."
echo "------------------------------------------------------------"

SERVICES=$(aws ecs list-services \
  --cluster "$CLUSTER_NAME" \
  --query "serviceArns[]" \
  --output text | xargs -n1 basename)

UPDATED_SERVICES=()
SKIPPED=0

for SERVICE in $SERVICES; do
  echo "------------------------------"
  echo "Service: $SERVICE"

  TASK_DEF=$(aws ecs describe-services \
    --cluster "$CLUSTER_NAME" \
    --services "$SERVICE" \
    --query "services[0].taskDefinition" \
    --output text)

  if [[ -z "$TASK_DEF" || "$TASK_DEF" == "None" ]]; then
    echo "⚠️  No task definition — skipping."
    ((SKIPPED++)) || true
    continue
  fi

  aws ecs describe-task-definition \
    --task-definition "$TASK_DEF" \
    --query "taskDefinition" \
    --output json > taskdef.json

  # Check if sidecar has the env var
  if ! jq -e '
        .containerDefinitions[]
        | select(.name | startswith("sidecar-"))
        | .environment[]?
        | select(.name=="TOKEN_CACHE_REFRESH_PRIOR_EXPIRATION")
      ' taskdef.json > /dev/null; then
    echo "✅ Env var not found in sidecar — skipping."
    ((SKIPPED++)) || true
    continue
  fi

  echo "⚡ Updating TOKEN_CACHE_REFRESH_PRIOR_EXPIRATION to 3595 ..."

  jq 'del(.status,.revision,.taskDefinitionArn,.requiresAttributes,.compatibilities,.registeredAt,.registeredBy,.deregisteredAt)
      |
      (.containerDefinitions) |= map(
        if (.name | startswith("sidecar-")) then
          .environment |= map(
            if .name=="TOKEN_CACHE_REFRESH_PRIOR_EXPIRATION"
            then .value="3595"
            else .
            end
          )
        else .
        end
      )
  ' taskdef.json > new-taskdef.json

  NEW_TASK_DEF=$(aws ecs register-task-definition \
    --cli-input-json file://new-taskdef.json \
    --query "taskDefinition.taskDefinitionArn" \
    --output text)

  echo "✅ Registered new task definition: $NEW_TASK_DEF"

  aws ecs update-service \
    --cluster "$CLUSTER_NAME" \
    --service "$SERVICE" \
    --task-definition "$NEW_TASK_DEF" > /dev/null

  echo "🚀 Service $SERVICE updated"
  UPDATED_SERVICES+=("$SERVICE")
done

echo "------------------------------"
echo "✅ Done."
echo "Updated services: ${#UPDATED_SERVICES[@]}"
echo "Skipped services: $SKIPPED"

if [[ ${#UPDATED_SERVICES[@]} -gt 0 ]]; then
  echo "🟢 Updated:"
  printf '   • %s\n' "${UPDATED_SERVICES[@]}"
fi