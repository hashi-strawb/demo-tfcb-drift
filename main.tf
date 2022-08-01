terraform {
  cloud {
    organization = "hashi_strawb_demo"

    workspaces {
      name = "demo-tfcb-drift"
    }
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }

    doormat = {
      source = "doormat.hashicorp.services/hashicorp-security/doormat"
    }
  }
}

# Find the arn for the AWS role we need
data "tfe_outputs" "aws-creds" {
  organization = "hashi_strawb_demo"
  workspace    = "bootstrap"

  lifecycle {
    # the output from the above must include roles
    postcondition {
      condition     = contains(keys(self.values), "roles")
      error_message = "Bootstrap workspace does not contain a 'roles' output variable; check remote state sharing configuration"
    }

    # and that role must include a value for this workspace
    postcondition {
      condition     = contains(keys(self.values.roles), terraform.workspace)
      error_message = "Bootstrap workspace does not contain a role for this workspace; ensure this workspace has the correct tags, then re-apply the bootstrap workspace"
    }
  }
}

provider "doormat" {}

data "doormat_aws_credentials" "creds" {
  role_arn = data.tfe_outputs.aws-creds.values.roles[terraform.workspace]
}

provider "aws" {
  access_key = data.doormat_aws_credentials.creds.access_key
  secret_key = data.doormat_aws_credentials.creds.secret_key
  token      = data.doormat_aws_credentials.creds.token
  region     = "us-east-1" # doesn't matter, but required by the provider

  default_tags {
    tags = {
      Name      = "StrawbTest"
      Owner     = "lucy.davinhart@hashicorp.com"
      Purpose   = "Demonstrating Drift Detection"
      TTL       = "24h"
      Terraform = "true"
      Source    = "https://github.com/hashi-strawb/demo-tfcb-drift"
      Workspace = terraform.workspace
    }
  }
}

data "aws_caller_identity" "current" {}


resource "aws_iam_role" "demo_drift_role" {
  name = "strawb-demo_drift_role"

  tags = {
    configured-with = "terraform"
  }

  assume_role_policy = <<-EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "sts:AssumeRole",
            "Principal": {
                "AWS": "${data.aws_caller_identity.current.account_id}"
            },
            "Condition": {}
        }
    ]
}
  EOF
}
