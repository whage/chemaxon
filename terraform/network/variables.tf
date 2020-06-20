variable "vpc_name" {
  type = string
  default = "sallai-test"
}

variable "vpc_cidr" {
  type = string
  default = "101.0.0.0/16"
}

variable "pub_subnet_a" {
  type = map(any)
  default = {
    cidr = "101.0.0.0/24"
    az = "eu-central-1a"
    name = "public-subnet-a"
  }
}

variable "pub_subnet_b" {
  type = map(any)
  default = {
    cidr = "101.0.1.0/24"
    az = "eu-central-1b"
    name = "public-subnet-b"
  }
}

variable "pub_rt_name" {
  type = string
  default = "public-subnet-route-table"
}

variable "priv_subnet_a" {
  type = map(any)
  default = {
    cidr = "101.0.2.0/24"
    az = "eu-central-1a"
    name = "public-subnet-a"
  }
}

variable "priv_subnet_b" {
  type = map(any)
  default = {
    cidr = "101.0.3.0/24"
    az = "eu-central-1b"
    name = "public-subnet-b"
  }
}

variable "priv_rt_name" {
  type = string
  default = "public-subnet-route-table"
}
