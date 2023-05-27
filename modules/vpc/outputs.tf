output "REGION" {
  value = var.REGION
}

output "PROJECT_NAME" {
  value = var.PROJECT_NAME
}

output "VPC_ID" {
  value = aws_vpc.vpc.id
}

output "PUB_SUB_1_A_ID" {
  value = aws_subnet.pub-sub-1-a.id
}
output "PUB_SUB_2_B_ID" {
  value = aws_subnet.pub-sub-2-b.id
}
output "PRI_SUB_3_A_ID" {
  value = aws_subnet.pri-sub-3-a.id
}

output "PRI_SUB_4_B_ID" {
  value = aws_subnet.pri-sub-4-b.id
}

output "PRI_SUB_5_A_ID" {
  value = aws_subnet.pri-sub-5-a.id
}

output "PRI_SUB_6_B_ID" {
    value = aws_subnet.pri-sub-6-b.id 
}

output "IGW_ID" {
    value = aws_internet_gateway.internet_gateway
}

