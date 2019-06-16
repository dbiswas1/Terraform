variable "m2go_aws_region" {
  description = "AWS Beijing region"
  type = map
  default = {
    beijing = "cn-north-1"
    ningixia = "cn-northwest-1"
    ver = "~> 2.13"
  }
}

variable "m2go_ami" {
  description = "AWS Region Wise AMI"
  type = "map"
  default = {
    cn-north-1 = "ami-0759521cef51f6a45"
    cn-northwest-1 = "ami-0759521cef51f6a45"
  }
}

variable "m2go_vpc_cidr" {
  description = "mifare2go Pilot VPC CIDR"
  type = string
  default = "10.0.0.0/16"
}

variable "m2go_public_subnet_cidr"{
  description = "mifare2go public subnet cidr"
  type = "map"
  default = {
    az1 = "10.0.1.0/24"
    az2 = "10.0.2.0/24"
  }
}

variable "m2go_private_subnet_cidr"{
  description = "mifare2go private subnet cidr"
  type = map
  default = {
    az3 = "10.0.3.0/24"
    az4 = "10.0.4.0/24"
  }
}
