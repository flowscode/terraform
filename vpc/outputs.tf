output "public_ips" {
  value = [
    "${aws_instance.public_server[*].tags["Name"]}", "${aws_instance.public_server[*].public_ip}",
  "${aws_instance.private_server[*].tags["Name"]}", "${aws_instance.private_server[*].public_ip}",
"${aws_instance.bastion_host.tags["Name"]}", "${aws_instance.bastion_host.public_ip}"]
}
output "private_ips" {
  value = [
    "${aws_instance.public_server[*].tags["Name"]}", "${aws_instance.public_server[*].private_ip}",
  "${aws_instance.private_server[*].tags["Name"]}", "${aws_instance.private_server[*].private_ip}",
"${aws_instance.bastion_host.tags["Name"]}", "${aws_instance.bastion_host.private_ip}"]
}
