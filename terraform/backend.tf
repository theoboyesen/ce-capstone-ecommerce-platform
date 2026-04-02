terraform {
  backend "s3" {
    bucket = "theo-capstone-tf-state-12345" # must be unique
    key    = "global/terraform.tfstate"
    region = "eu-west-2"
  }
}