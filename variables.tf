variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "subnet_cidr" {
  type    = list(string)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "proj_name" {
  type    = string
  default = "ephemral-runner"
}

data "aws_availability_zones" "available" {
  state = "available"
}
