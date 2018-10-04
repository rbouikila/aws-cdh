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

resource "aws_instance" "web" {
  ami           = "${data.aws_ami.redhat.id}"
  instance_type = "t2.micro"
  count         = 3
  tags {
    Name = "${format("master%02d", count.index + 1)}"
  }
  subnet_id     = "${element(data.aws_subnet_ids.private.ids, count.index)}"
  
  root_block_device {
    volume_type           = "io1"
    volume_size           = "200"
    iops                  = "1000"
    delete_on_termination = true
  }
}