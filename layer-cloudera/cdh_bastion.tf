
resource "aws_instance" "cdh_bastion" {
  ami           = "${data.aws_ami.redhat.id}"
  instance_type = "t2.micro"
  count         = 1
  key_name      = "${aws_key_pair.cloudera-ssh-accorhotels.key_name}"
  subnet_id     = "${data.terraform_remote_state.layer-base.sn_public_a_id}"

  tags {
    Name = "${format("bastion%02d", count.index + 1)}"
    Type = "bastion"
  }
}

resource "aws_security_group" "allow_bastion_ssh" {
  name        = "allow_bastion_ssh"
  description = "Allow SSH traffic"
  vpc_id      = "${data.terraform_remote_state.layer-base.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # allow SSH to private subnet
  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${data.terraform_remote_state.layer-base.vpc_cidr}"]
  }
}



# Security group for master/worker
resource "aws_security_group" "allow_bastion_master" {
  name        = "allow_bastion_master"
  description = "Allow SSH traffic"
  vpc_id      = "${data.terraform_remote_state.layer-base.vpc_id}"
}

resource "aws_security_group" "allow_bastion_worker" {
  name        = "allow_bastion_worker"
  description = "Allow SSH traffic"
  vpc_id      = "${data.terraform_remote_state.layer-base.vpc_id}"
}

resource "aws_security_group_rule" "allow_ssh_bastion_master" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.allow_bastion_ssh.id}"

  security_group_id = "${aws_security_group.allow_bastion_master.id}"
}

resource "aws_security_group_rule" "allow_ssh_bastion_worker" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.allow_bastion_ssh.id}"

  security_group_id = "${aws_security_group.allow_bastion_worker.id}"
}