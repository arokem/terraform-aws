variable "profile" {
  default = "default"
}

variable "region" {
  default = "us-east-1"
}

variable "bucket_name" {
  default = "terraform-hcphub-state-arokem"
}

variable "dynamo_table_name" {
  default = "terraform-hcphub-locks-arokem"
}
