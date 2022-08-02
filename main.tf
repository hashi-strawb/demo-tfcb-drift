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
  name         = "demo-tfcb-drift"
  organization = "hashi_strawb_demo"
  tag_names    = ["demo:tfcb"]

  vcs_repo {
    identifier     = "hashi-strawb/demo-tfcb-drift"
    oauth_token_id = "ot-hgXVE3ukvEeULkPU"
  }

  lifecycle {
    prevent_destroy = true
  }
}
