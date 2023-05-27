# allocate elastic ip. this eip will be used for the nat-gateway in the public subnet pub-sub-1-a
resource "aws_eip" "EIP-NAT-GW-A" {
  vpc    = true

  tags   = {
    Name = "NAT-GW-EIP-A"
  }
}

# allocate elastic ip. this eip will be used for the nat-gateway in the public subnet pub-sub-2-b
resource "aws_eip" "EIP-NAT-GW-B" {
  vpc    = true

  tags   = {
    Name = "NAT-GW-EIP-B"
  }
}

# create nat gateway in public subnet pub-sub-1-a
resource "aws_nat_gateway" "NAT-GW-A" {
  allocation_id = aws_eip.EIP-NAT-GW-A.id
  subnet_id     = var.PUB_SUB_1_A_ID

  tags   = {
    Name = "NAT-GW-A"
  }

  # to ensure proper ordering, it is recommended to add an explicit dependency
  depends_on = [var.IGW_ID]
}

# create nat gateway in public subnet pub-sub-1-a
resource "aws_nat_gateway" "NAT-GW-B" {
  allocation_id = aws_eip.EIP-NAT-GW-B.id
  subnet_id     = var.PUB_SUB_2_B_ID

  tags   = {
    Name = "NAT-GW-B"
  }

  # to ensure proper ordering, it is recommended to add an explicit dependency
  # on the internet gateway for the vpc.
  depends_on = [var.IGW_ID]
}

# create private route table Pri-RT-A and add route through NAT-GW-A
resource "aws_route_table" "Pri-RT-A" {
  vpc_id            = var.VPC_ID

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.NAT-GW-A.id
  }

  tags   = {
    Name = "Pri-RT-A"
  }
}

# associate private subnet pri-sub-3-a with private route table Pri-RT-A
resource "aws_route_table_association" "pri-sub-3-a-with-Pri-RT-A" {
  subnet_id         = var.PRI_SUB_3_A_ID
  route_table_id    = aws_route_table.Pri-RT-A.id
}

# associate private subnet pri-sub-5-a with private route table Pri-RT-A
resource "aws_route_table_association" "pri-sub-4-b-with-Pri-RT-B" {
  subnet_id         = var.PRI_SUB_5_A_ID
  route_table_id    = aws_route_table.Pri-RT-A.id
}

# create private route table Pri-RT-B and add route through NAT-GW-B
resource "aws_route_table" "Pri-RT-B" {
  vpc_id            = var.VPC_ID

  route {
    cidr_block      = "0.0.0.0/0"
    nat_gateway_id  = aws_nat_gateway.NAT-GW-B.id
  }

  tags   = {
    Name = "Pri-RT-B"
  }
}

# associate private subnet pri-sub-4-b with private route Pri-RT-B
resource "aws_route_table_association" "pri-sub-5-a-with-Pri-RT-B" {
  subnet_id         = var.PRI_SUB_4_B_ID
  route_table_id    = aws_route_table.Pri-RT-B.id
}

# associate private subnet pri-sub-6-b with private route table Pri-RT-B
resource "aws_route_table_association" "pri-sub-6-b-with-Pri-RT-B" {
  subnet_id         = var.PRI_SUB_6_B_ID
  route_table_id    = aws_route_table.Pri-RT-B.id
}