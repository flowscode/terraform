output "public_ip_0" {
  value = aws_instance.my_server[0].public_ip
}
output "public_ip_1" {
  value = aws_instance.my_server[1].public_ip
}
