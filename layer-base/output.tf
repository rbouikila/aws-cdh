output "sn_public_a_id" {
  value = "${aws_subnet.cloudera_sn_public_a.id}"
}

output "sn_public_b_id" {
  value = "${aws_subnet.cloudera_sn_public_b.id}"
}

output "sn_public_c_id" {
  value = "${aws_subnet.cloudera_sn_public_c.id}"
}

output "vpc_id" {
  value = "${aws_vpc.cloudera_vpc.id}"
}

output "vpc_cidr" {
  value = "${var.vpc_cidr}"
}

output "private_dns_zone" {
  value = "${var.private_dns_zone}"
}
