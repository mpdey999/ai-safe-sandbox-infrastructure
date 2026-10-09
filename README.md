# Phase Zero — Azure Container Apps foundation (Harness + Terraform)

This is a **starter template** for a client-approved Azure sandbox POC. It provisions:
- Resource Group
- Log Analytics workspace
- Azure Container Registry (ACR)
- Virtual Network and dedicated Container Apps subnet
- User-assigned managed identity with `AcrPull`
- Azure Container Apps Environment
- A starter Azure Container App using Microsoft's public hello-world image

The starter app uses a public Microsoft sample image so you can verify the infrastructure before your private JFrog → ACR image promotion is implemented. It does **not** deploy VS Code Server yet.

## Important before use
1. The subscription and tenant IDs are identifiers, not credentials. Do not commit client secrets, passwords, tokens, or state files.
2. Confirm with the client/network team whether the environment must be internal/private or external. `internal_environment` defaults to `false` for initial reachability testing; change it only after confirming network/DNS/access requirements.
3. Confirm the target Azure region, resource naming, approved VNet CIDRs, subnet size, and whether a new ACR/VNet is permitted. Defaults are examples and must be reviewed.
4. Azure Container Apps workload-profile environments using a custom infrastructure subnet need an appropriately sized dedicated subnet (commonly /27 minimum). Check the requirements for the exact environment type and provider version before applying. Do not use an overlapping CIDR.
5. The pipeline must have permission to create resources and role assignments. `Owner` or `User Access Administrator` is not automatically required for every deployment, but role assignment creation needs appropriate permissions. Use the least privilege approved by the client.
6. **Terraform state must be persistent and shared between runs.** Do not rely on ephemeral CI workspace state. Configure Harness-managed Terraform state if available, or an approved Azure Storage remote backend. The included pipeline is a starting template and intentionally stops before apply until state and authentication are configured.
7. Run a plan and review every create/update/delete before approval. Never apply a plan that unexpectedly replaces shared networking, ACR, or other shared resources.

## Files
- `terraform/` — Azure infrastructure code
- `harness/pipeline-phase-zero.yaml` — Harness CI pipeline starter template
- `harness/SETUP.md` — connector, secret, state, and pipeline setup
- `terraform/dev.tfvars.example` — example inputs
- `.gitignore` — ignores state, plans, and secrets

## Terraform commands (local validation only; deployment should run through Harness)
```bash
terraform -chdir=terraform init
terraform -chdir=terraform fmt -check -recursive
terraform -chdir=terraform validate
```
Do not run `apply` locally if your client requires all provisioning through Harness.

## Deployment strategy
1. Review and edit `terraform/dev.tfvars.example`; copy it to `terraform/dev.tfvars` only if you intend to keep it out of Git.
2. Create/configure Harness connectors and secrets as described in `harness/SETUP.md`.
3. Configure persistent Terraform state.
4. Import this pipeline YAML into Harness or create the pipeline in the UI and use the YAML as a reference. Harness pipeline schemas and available steps vary by account/module version; validate it in your Harness project before running.
5. Run `fmt`, `init`, `validate`, and `plan`; review the plan.
6. Apply only after approval and client authorization.
7. Re-run plan to confirm there are no unexpected changes.

## Costs and cleanup
ACR, Log Analytics, Container Apps networking, and running replicas may incur charges. Keep the test environment small and follow the client's retention policy. Do not destroy client resources without explicit approval.
