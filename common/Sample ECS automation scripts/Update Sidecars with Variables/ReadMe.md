# ECS Sidecar Env Vars Updater (All Services in a Cluster)

## Note:
Be careful with region and cluster variables

A Bash script that iterates over **all ECS services** in a given cluster and, for any service whose task definition includes a **sidecar container** (container name starts with `sidecar-`), it **upserts** specific environment variables, registers a **new task definition revision**, and updates the service to use it.

## What it changes

For every container in the task definition where the container name starts with `sidecar-`, the script upserts these env vars:

- `TOKEN_CACHE_REFRESH_PRIOR_EXPIRATION=3950`
- `TOKEN_CACHE_MAX_CAPACITY=6300`
- `KC_AUTHORIZATION_CACHE_MAX_SIZE=5000`

“Upsert” means:
- If the variable exists → its value is updated
- If it doesn’t exist → it is added

## How it works (high level)

For each ECS service in the cluster:

1. Fetch the service `taskDefinition`
2. Download the full task definition JSON (`describe-task-definition`)
3. Detect whether a sidecar container exists (`jq` checks `containerDefinitions[].name` starts with `sidecar-`)
4. If sidecar exists:
   - Remove non-registrable fields from the task definition JSON (like `revision`, `taskDefinitionArn`, etc.)
   - Upsert env vars into matching containers
   - Register a new task definition revision
   - Update the service to use the newly registered revision
5. Print a summary: updated services and skip counts

## Usage

1. Simply run it from browser using CloudShell
2. Save the script as (example) `UpdateSidecars.sh` localy and run it with previously provided credentials

