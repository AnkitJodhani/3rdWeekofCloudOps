
output "JUMP_SERVER_IP" {
  value = aws_instance.jump_server.public_ip
}
