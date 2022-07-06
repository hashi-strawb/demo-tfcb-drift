terraform {
  cloud {
    organization = "lmhd"

    workspaces {
      name = "demo-tfcb-drift"
    }
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

data "aws_caller_identity" "current" {}


resource "aws_iam_role" "demo_drift_role" {
  name = "demo_drift_role"

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
