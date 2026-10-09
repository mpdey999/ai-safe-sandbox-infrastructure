terraform {
  required_version = ">= 1.5.7, < 2.0.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }

  # Configure persistent state before using this in a repeatable Harness pipeline.
  # Recommended: Harness-managed Terraform state, if enabled for your account,
  # or an approved Azure Storage backend configured with `terraform init -backend-config=...`.
  # Do not keep state only in an ephemeral CI workspace.
}
