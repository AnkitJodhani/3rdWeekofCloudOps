
# launch the ec2 instance in pub-sub-1-a
resource "aws_instance" "jump_server" {
  ami                    = var.AMI
  instance_type          = var.CPU
  subnet_id              = var.PUB_SUB_1_A_ID
  vpc_security_group_ids = [var.JUMP_SG_ID]
  key_name               = var.KEY_NAME

  tags = {
    Name = "jump_server"
  }
}




