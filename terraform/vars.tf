variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  default = "my_vpc"
}

variable "subnet_cidr" {
  default = "10.0.1.0/24"
}

variable "subnet_AZ" {
  default = "us-east-1a"
}

variable "subnet_name" {
  default = "public_subnet"
}

variable "igw_name" {
  default = "MyIGW"
}

variable "rt_name" {
  default = "public_rt"
}

variable "instance_sg" {
  default = "my_sg"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "instance_key_pair" {
  default = "tobar"
}

variable "instance_name" {
  default = "docker_server"
}