
output "ALB_SG_ID" {
  value = aws_security_group.alb_sg.id
}

output "CLIENT_SG_ID" {
  value = aws_security_group.client_sg.id
}

output "DB_SG_ID" {
  value = aws_security_group.db_sg.id
}
output "JUMP_SG_ID" {
  value = aws_security_group.jump_sg.id
}

