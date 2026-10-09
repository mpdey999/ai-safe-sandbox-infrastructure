# Harness setup — Phase Zero

## 1. Required connectors
In the Harness project, create or verify:
- **GitHub connector** with read access to the repository/branch containing this code.
- **Azure connector** using the client's approved auth method. Use the exact subscription and tenant that are approved for this POC.
- **Harness Delegate / CI execution** capable of running Terraform and reaching Azure/provider registries.

Connector names in your Harness account are account-specific. Update `pipeline-phase-zero.yaml` references to match your connector IDs.

## 2. Azure permissions
Ask the Azure administrator to grant the Harness identity the minimum required permissions. The Terraform configuration creates a Resource Group and resources and also creates an `AcrPull` role assignment for a managed identity. That role assignment requires `Microsoft.Authorization/roleAssignments/write` at the target scope (or an equivalent approved permission). Do not assume Contributor alone is sufficient for role assignments.

## 3. Secrets / authentication
Do not place client secrets in Git. If the selected Harness execution step uses Azure service-principal environment authentication, create Harness secrets for:
- `ARM_CLIENT_ID`
- `ARM_CLIENT_SECRET`
- `ARM_TENANT_ID`
- `ARM_SUBSCRIPTION_ID`

The client secret must be a Harness Secret Manager secret reference, not a literal. If your Harness Azure connector uses workload identity/OIDC or another supported auth flow, use that method instead; do not add an unnecessary client secret. The pipeline YAML contains placeholders and must be adapted to your Harness account's supported syntax.

## 4. Terraform state — must be configured before repeatable execution
Do not run repeated CI jobs with only local state in an ephemeral workspace. Choose one of these:
1. Harness-managed Terraform state / IaCM state management if enabled and supported by your account; or
2. An approved Azure Storage remote backend with an existing storage account and container.

For Azure Storage backend, supply backend settings at `terraform init` time (for example storage account, container, key, and resource group) using secure Harness variables. Backend configuration cannot interpolate normal Terraform input variables. Do not commit access keys or SAS tokens. Prefer Azure AD authentication for the backend if supported by your setup.

The state-storage bootstrap is intentionally not included because the backend must exist before the main configuration can initialize against it. Create it using the client's approved bootstrap process or Harness state-management capability.

## 5. Import / create pipeline
1. Push this folder to GitHub.
2. In Harness, create a pipeline in the intended project.
3. Use the GitHub connector and select the repository and branch.
4. Import/paste `pipeline-phase-zero.yaml` if your Harness version supports YAML import, then fix connector IDs and any schema differences shown by Harness validation.
5. Configure persistent Terraform state before apply.
6. Add Harness secrets or approved workload identity authentication.
7. First run only `fmt`, `init`, `validate`, and `plan`.
8. Review the plan carefully and obtain client approval.
9. Enable apply only after the plan and state backend are approved.

## 6. First-run checks
- ACR name is globally unique.
- VNet/subnet CIDRs are approved and do not overlap.
- Environment type and subnet size are appropriate.
- `internal_environment` matches the intended access model.
- The test image's listening port matches `container_port`.
- Resource names comply with client naming/tagging standards.
- The plan does not replace shared resources.
