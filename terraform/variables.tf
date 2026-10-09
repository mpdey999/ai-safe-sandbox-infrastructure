variable "subscription_id" {
  description = "Azure subscription ID. Use a Harness variable or approved non-secret config."
  type        = string
}

variable "tenant_id" {
  description = "Azure tenant ID."
  type        = string
}

variable "location" {
  description = "Azure region approved for the POC."
  type        = string
  default     = "centralindia"
}

variable "resource_group_name" {
  description = "Name of the dedicated Phase Zero Resource Group."
  type        = string
  default     = "rg-ai-safe-sandbox-phase0-poc"
}

variable "acr_name" {
  description = "Globally unique Azure Container Registry name (5-50 alphanumeric characters)."
  type        = string
  # Set this in dev.tfvars.example before running. ACR names are globally unique.
}

variable "log_analytics_name" {
  description = "Log Analytics workspace name."
  type        = string
  default     = "law-ai-safe-sandbox-phase0"
}

variable "vnet_name" {
  description = "Virtual Network name."
  type        = string
  default     = "vnet-ai-safe-sandbox-phase0"
}

variable "vnet_address_space" {
  description = "Must be approved and must not overlap with client networks."
  type        = list(string)
  default     = ["10.80.0.0/16"]
}

variable "aca_subnet_name" {
  description = "Dedicated subnet for the Container Apps Environment."
  type        = string
  default     = "snet-aca-infrastructure"
}

variable "aca_subnet_address_prefixes" {
  description = "Dedicated non-overlapping subnet. Validate sizing against selected ACA environment type."
  type        = list(string)
  default     = ["10.80.1.0/27"]
}

variable "internal_environment" {
  description = "Set true only if client requires an internal-only environment and provides required private DNS/network access."
  type        = bool
  default     = false
}

variable "container_app_name" {
  description = "Initial smoke-test Container App name."
  type        = string
  default     = "ca-ai-safe-sandbox-smoke"
}

variable "container_image" {
  description = "Approved image for the initial smoke test; replace later with the approved ACR image."
  type        = string
  default     = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
}

variable "container_port" {
  description = "Port on which the selected test container listens."
  type        = number
  default     = 80
}

variable "app_min_replicas" {
  description = "Minimum replicas for the smoke-test app."
  type        = number
  default     = 0
}

variable "app_max_replicas" {
  description = "Maximum replicas for the smoke-test app."
  type        = number
  default     = 1
}

variable "tags" {
  description = "Required client cost-allocation and ownership tags. Add client-required tags before deployment."
  type        = map(string)
  default = {
    workload    = "ai-safe-sandbox"
    environment = "poc"
    managed_by  = "terraform"
  }
}
