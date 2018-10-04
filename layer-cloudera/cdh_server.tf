
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

resource "aws_instance" "cdh_server" {
  ami           = "${data.aws_ami.redhat.id}"
  instance_type = "t2.micro"
  count         = 3
  tags {
    Name = "${format("master%02d", count.index + 1)}"
  }
  subnet_id     = "${element(data.aws_subnet_ids.private.ids, count.index)}"
  
  root_block_device {
    volume_type           = "io1"
    volume_size           = "50"
    iops                  = "1000"
    delete_on_termination = true
  }

  ebs_block_device {
    device_name           = "/dev/xvdb"
    volume_type           = "gp2"
    volume_size           = "200"
    iops                  = "15000"
  }

  ebs_block_device {
    device_name           = "/dev/xvdc"
    volume_type           = "gp2"
    volume_size           = "200"
    iops                  = "15000"
  }

  ebs_block_device {
    device_name           = "/dev/xvdd"
    volume_type           = "gp2"
    volume_size           = "200"
    iops                  = "15000"
  }
}