
resource "aws_instance" "cdh_server" {
  ami           = "${data.aws_ami.redhat.id}"
  instance_type = "t2.micro"
  vpc_security_group_ids      = ["${aws_security_group.allow_bastion_master.id}"]
  count         = 3
  key_name      = "${aws_key_pair.cloudera-ssh-accorhotels.key_name}"
  subnet_id     = "${element(data.aws_subnet_ids.private.ids, count.index)}"

  tags {
    Name = "${format("master%02d", count.index + 1)}"
  }

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