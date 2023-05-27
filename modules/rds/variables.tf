variable "DB_SG_ID" {}
variable "PRI_SUB_5_A_ID" {}
variable "PRI_SUB_6_B_ID" {}
variable "DB_USERNAME" {}
variable "DB_PASSWORD" {}
variable "DB_SUB_NAME" {
    default = "book-shop-db-subnet-a-b"
}
variable "DB_NAME" {
    default = "test"
}