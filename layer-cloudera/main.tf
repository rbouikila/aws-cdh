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
    values = ["redhat/images/hvm-ssd/RHEL-7.5_HVM_GA*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["309956199498"] # Red hat
}

resource "aws_instance" "web" {
  ami           = "${data.aws_ami.redhat.id}"
  instance_type = "t2.micro"
  count         = 3
}