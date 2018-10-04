provider "aws" {
  region = "${var.region}"
}

terraform {
  backend "s3" {
    bucket = "cloudera-deploiement-terraform"
    key    = "layer-base"
    region = "eu-west-1"
  }
}

