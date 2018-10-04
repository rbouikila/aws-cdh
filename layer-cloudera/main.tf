provider "aws" {
  region = "${var.region}"
}

data "terraform_remote_state" "layer-base" {
 backend = "s3"
 bucket   config {
    bucket = "cloudera-deploiement-terraform"
    key    = "layer-base"
    region = "eu-west-1"
  }
}