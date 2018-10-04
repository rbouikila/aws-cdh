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

data "aws_ami" "redhat" {
  
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-7.5_HVM_GA*"]
  }

  owners = ["309956199498"] # Red hat
}

data "aws_subnet_ids" "private" {
  vpc_id = "${data.terraform_remote_state.layer-base.vpc_id}"
  tags {
    Name = "cloudera_sn_private_*"
  }
}