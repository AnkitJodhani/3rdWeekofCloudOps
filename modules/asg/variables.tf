variable "PROJECT_NAME"{}
variable "AMI" {
    default = "ami-053b0d53c279acc90"
}
variable "CPU" {
    default = "t2.micro"
}
variable "KEY_NAME" {}
variable "CLIENT_SG_ID" {}
variable "MAX_SIZE" {
    default = 6
}
variable "MIN_SIZE" {
    default = 2
}
variable "DESIRED_CAP" {
    default = 3
}
variable "asg_health_check_type" {
    default = "ELB"
}
variable "PRI_SUB_3_A_ID" {}
variable "PRI_SUB_4_B_ID" {}
variable "TG_ARN" {}