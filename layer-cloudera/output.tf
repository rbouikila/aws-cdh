output "bastion" {
    value = "${aws_instance.cdh_bastion.public_dns}"
}