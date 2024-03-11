terraform {
    required_providers {
        aws = {
            source  = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
    backend "s3" {
        bucket         = "cloud-public-quarkus-lambda-tf-stack"
        key            = "terraform/states/cloud-public-quarkus-lambda-tf-stack"
        region         = "eu-west-3"
        encrypt        = "true"
        dynamodb_table = "cloud-public-quarkus-lambda-tf-stack-lock"
    }
}

provider "aws" {
    profile = var.aws_profile
    region  = var.aws_region
}

resource "aws_s3_bucket" "bucket" {
    bucket = "cloud-public-quarkus-lambda-tf-stack"

    versioning {
        enabled = true
    }
    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }
    object_lock_configuration {
        object_lock_enabled = "Enabled"
    }
    tags = {
        Name = "S3 Remote Terraform State Store"
    }
}

resource "aws_dynamodb_table" "terraform-lock" {
    name           = "terraform_state"
    read_capacity  = 5
    write_capacity = 5
    hash_key       = "LockID"
    attribute {
        name = "LockID"
        type = "S"
    }
    tags = {
        "Name" = "DynamoDB Terraform State Lock Table"
    }
}
