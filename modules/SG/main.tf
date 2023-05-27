# create security group for the application load balancer
resource "aws_security_group" "alb_sg" {
  name        = "alb security group"
  description = "enable http/https access on port 80/443"
  vpc_id      = var.VPC_ID

  ingress {
    description = "http access"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "https access"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ALB_SG"
  }
}

# create security group for the Client
resource "aws_security_group" "client_sg" {
  name        = "client_sg"
  description = "enable http/https access on port 80 for elb sg"
  vpc_id      = var.VPC_ID

  ingress {
    description     = "http access"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Client_sg"
  }
}

# create security group for the Database
resource "aws_security_group" "db_sg" {
  name        = "db_sg"
  description = "enable mysql access on port 3305 from client-sg"
  vpc_id      = var.VPC_ID

  ingress {
    description     = "mysql access"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.client_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Database_sg"
  }
}

# create security group for the Bastion host or Jump server
resource "aws_security_group" "jump_sg" {
  name        = "jump_sg"
  description = "enable ssh access on port 22 "
  vpc_id      = var.VPC_ID

  ingress {
    description     = "ssh access"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "jump_sg"
  }
}