# Create S3 + DynamoDB for remote terraform state
# =======================
terraform {
  required_version = ">= 0.12.0"
}

# After first terraform apply, store state in S3 by uncommenting, and re-running `terraform init`
# variables not allowed in backend config, so you must manually enter bucket, region, table
# DON'T  INCLUDE THIS PART IN THIS FOLDER
# Put the following into the other folders where you want the state stored.
# Can't store this state, unfortunately
terraform {
 backend "s3" {
   bucket         = "terraform-hcphub-state-arokem"
   key            = "global/s3/terraform.tfstate"
   region         = "us-east-1"
   dynamodb_table = "terraform-hcphub-locks-arokem"
   encrypt        = true
 }
}

provider "aws" {
  version     = "~> 2.40"
  profile     = var.profile
  region      = var.region
}


output "s3_bucket_arn" {
  value       = aws_s3_bucket.terraform_state.arn
  description = "The ARN of the S3 bucket"
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.terraform_locks.name
  description = "The name of the DynamoDB table"
}


resource "aws_s3_bucket" "terraform_state" {
  bucket        = var.bucket_name
  force_destroy = true
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
}

resource "aws_dynamodb_table" "terraform_locks" {
  name         = var.dynamo_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"
  attribute {
    name = "LockID"
    type = "S"
  }
}
