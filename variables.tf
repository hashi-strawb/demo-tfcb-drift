variable "workspace_name" {
  type        = string
  description = "The name of the workspace to be managed. If you like, this can be the same workspace as the one linked to this repo"
  default     = "demo-tfcb-drift"
}

variable "organization" {
  type        = string
  description = "Terraform Cloud organization in which to create/manage the workspace"
  default     = "hashi_strawb_demo"
}

variable "workspace_tags" {
  type        = list(string)
  description = "Tags Terraform is expecting to see on the Workspace"
  default = [
    "demo:tfcb"
  ]
}

variable "vcs_repo" {
  type        = string
  description = "VCS repo to link workspace to"
  default     = "hashi-strawb/demo-tfcb-drift"
}

variable "oauth_token_id" {
  type        = string
  description = "OAuth Token ID to connect to VCS repo"
  default     = "ot-hgXVE3ukvEeULkPU"
}
