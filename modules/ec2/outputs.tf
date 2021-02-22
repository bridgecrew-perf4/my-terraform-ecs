output "ec2_public_dns_name" {
    value = "${aws_instance.instance.*.public_dns}"
}

output "ec2_public_ip" {
    value = aws_instance.instance.*.public_ip
}
