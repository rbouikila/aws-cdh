provider "aws" {
  region = "${var.region}"
}

variable "region" {
  default = "eu-west-1"
}

data "terraform_remote_state" "layer-base" {
 backend = "s3"
 config {
    bucket = "cloudera-deploiement-terraform"
    key    = "layer-base"
    region = "eu-west-1"
  }
}

resource "aws_key_pair" "cloudera-ssh-accorhotels" {
  key_name   = "cloudera-ssh-accorhotels"
  public_key = "${file("~/.ssh/id_rsa.pub")}"
}