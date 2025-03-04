
resource "aws_instance" "cdh_bastion" {
  ami           = "${data.aws_ami.redhat.id}"
  instance_type = "t2.micro"
  vpc_security_group_ids      = ["${aws_security_group.allow_bastion_ssh.id}"]
  count         = 1
  associate_public_ip_address = true
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

  # allow ICMP to private subnet
  egress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
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

resource "aws_security_group_rule" "allow_icmp_bastion_master" {
  type                     = "ingress"
  from_port                = -1
  to_port                  = -1
  protocol                 = "icmp"
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

resource "aws_security_group_rule" "allow_icmp_bastion_worker" {
  type                     = "ingress"
  from_port                = -1
  to_port                  = -1
  protocol                 = "icmp"
  source_security_group_id = "${aws_security_group.allow_bastion_ssh.id}"

  security_group_id = "${aws_security_group.allow_bastion_worker.id}"
}

# Allow http/https
resource "aws_security_group_rule" "allow_https_bastion_worker" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  cidr_blocks              = [ "0.0.0.0/0" ]

  security_group_id = "${aws_security_group.allow_bastion_worker.id}"
}

resource "aws_security_group_rule" "allow_http_bastion_worker" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  cidr_blocks              = [ "0.0.0.0/0" ]

  security_group_id = "${aws_security_group.allow_bastion_worker.id}"
}

