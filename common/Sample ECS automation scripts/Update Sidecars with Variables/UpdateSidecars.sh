#!/bin/bash
set -euo pipefail

export AWS_REGION=us-east-1
export AWS_DEFAULT_REGION=us-east-1

CLUSTER_NAME="<CLUSTER>"
export AWS_PAGER=""

echo "🔎 Updating sidecar env vars for ALL services in cluster $CLUSTER_NAME ..."
echo "------------------------------------------------------------"

SERVICES=$(aws ecs list-services \
  --cluster "$CLUSTER_NAME" \
  --query "serviceArns[]" \
  --output text | xargs -n1 basename)

UPDATED_SERVICES=()
SKIPPED_NO_SIDECAR=0
SKIPPED_NO_TASKDEF=0

for SERVICE in $SERVICES; do
  echo "------------------------------"
  echo "Service: $SERVICE"

  TASK_DEF=$(aws ecs describe-services \
    --cluster "$CLUSTER_NAME" \
    --services "$SERVICE" \
    --query "services[0].taskDefinition" \
    --output text)

  if [[ -z "$TASK_DEF" || "$TASK_DEF" == "None" ]]; then
    echo "⚠️  taskDefinition is None — skipping."
    ((SKIPPED_NO_TASKDEF++)) || true
    continue
  fi

  aws ecs describe-task-definition \
    --task-definition "$TASK_DEF" \
    --query "taskDefinition" \
    --output json > taskdef.json

  if ! jq -e '.containerDefinitions[] | select(.name | startswith("sidecar-"))' taskdef.json > /dev/null; then
    echo "✅ No sidecar container found — skipping."
    ((SKIPPED_NO_SIDECAR++)) || true
    continue
  fi

  echo "⚡ Sidecar container(s) found — upserting env vars..."

  jq 'del(.status,.revision,.taskDefinitionArn,.requiresAttributes,.compatibilities,.registeredAt,.registeredBy,.deregisteredAt)
      |
      def upsert_env($k; $v):
        if any(.[]?; .name == $k) then
          map(if .name == $k then .value = $v else . end)
        else
          . + [{"name": $k, "value": $v}]
        end;

      (.containerDefinitions) |= map(
        if (.name | startswith("sidecar-")) then
          .environment = (
            (.environment // [])
            | upsert_env("TOKEN_CACHE_REFRESH_PRIOR_EXPIRATION"; "3950")
            | upsert_env("TOKEN_CACHE_MAX_CAPACITY"; "6300")
            | upsert_env("KC_AUTHORIZATION_CACHE_MAX_SIZE"; "5000")
          )
        else
          .
        end
      )
  ' taskdef.json > new-taskdef.json

  NEW_TASK_DEF=$(aws ecs register-task-definition \
    --cli-input-json file://new-taskdef.json \
    --query "taskDefinition.taskDefinitionArn" \
    --output text)

  echo "✅ Registered new Task Definition: $NEW_TASK_DEF"

  aws ecs update-service \
    --cluster "$CLUSTER_NAME" \
    --service "$SERVICE" \
    --task-definition "$NEW_TASK_DEF" > /dev/null

  echo "🚀 Service $SERVICE updated"
  UPDATED_SERVICES+=("$SERVICE")
done

echo "------------------------------"
echo "✅ All services processed."
echo "Updated: ${#UPDATED_SERVICES[@]}"
echo "Skipped (no sidecar): $SKIPPED_NO_SIDECAR"
echo "Skipped (no taskDef): $SKIPPED_NO_TASKDEF"

if [[ ${#UPDATED_SERVICES[@]} -gt 0 ]]; then
  echo "🟢 Updated services:"
  printf '   • %s\n' "${UPDATED_SERVICES[@]}"
fi