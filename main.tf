terraform {
  cloud {
    organization = "hashi_strawb_demo"

    workspaces {
      name = "demo-tfcb-drift"
    }
  }

  required_providers {
    tfe = {
      source = "hashicorp/tfe"
    }
  }
}

resource "tfe_workspace" "this" {
  name         = var.workspace_name
  organization = var.organization
  tag_names    = var.workspace_tags
  description  = "Demonstrate Drift Detection"

  vcs_repo {
    identifier     = var.vcs_repo

# TODO: variable for that, or data source
github_app_installation_id = "ghain-3JcBMQW48TPfPn4f"
  }

  lifecycle {
    # As I am managing my own workspace, do not allow me to destroy the workspace
    prevent_destroy = true
  }
}
