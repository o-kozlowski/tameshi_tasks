variable "AWS_REGION" {
    default = "eu-west-1"
}
variable "AWS_PROFILE" {
    type = string
    default = "default"
}
variable "BASTION_HOST_AMI" {
    type = string
    default = "ami-0069d66985b09d219"
}
variable "BASTION_HOST_INSTANCE_TYPE" {
    type = string
    default = "t3.micro"
}
variable "BASTION_HOST_CIDR" {
    type = string
    default = "83.26.152.42/32"
}