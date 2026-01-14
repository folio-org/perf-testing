# ECS Sidecar Env Var Updater – TOKEN_CACHE_REFRESH_PRIOR_EXPIRATION

A sample of Bash script that iterates over **all ECS services** in a cluster and updates the
`TOKEN_CACHE_REFRESH_PRIOR_EXPIRATION` environment variable **to `3595`** in
**sidecar containers** only.

A *sidecar container* is identified by a container name that **starts with `sidecar-`**.

---

## What this script does

For every ECS service in the specified cluster:

1. Retrieves the service’s task definition
2. Checks whether any `sidecar-*` container contains  
   `TOKEN_CACHE_REFRESH_PRIOR_EXPIRATION`
3. If the variable exists:
   - Updates its value to `3595`
   - Registers a new task definition revision
   - Updates the ECS service to use the new revision
4. If the variable does **not** exist:
   - Skips the service (no changes made)

This is a **safe, non-upserting** script:  
➡️ it **does not add** the variable if it is missing.

---
## Usage

1. Simply run it from browser using CloudShell
2. Save the script as (example) `UpdateSidecars.sh` localy and run it with previously provided credentials
