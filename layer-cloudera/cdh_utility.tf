
resource "aws_instance" "cdh_utility" {
  ami           = "${data.aws_ami.redhat.id}"
  instance_type = "t2.micro"
  vpc_security_group_ids      = ["${aws_security_group.allow_bastion_worker.id}"]
  count         = 1
  key_name      = "${aws_key_pair.cloudera-ssh-accorhotels.key_name}"
  subnet_id     = "${element(data.aws_subnet_ids.private.ids, count.index)}"

  tags {
    Name = "${format("utility%02d", count.index + 1)}"
    Type = "utilitynode"
  }

  root_block_device {
    volume_type           = "io1"
    volume_size           = "100"
    iops                  = "1000"
    delete_on_termination = true
  }

}
