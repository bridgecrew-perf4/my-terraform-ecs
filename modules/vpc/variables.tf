variable "vpc_cidr" {
  description = "My vpc cidr"
  default = "10.0.0.0/16"
}

variable "vpc_name" {
  description = "My vpc name"
  default = "ecs-vpc"
}

variable "name" {
  description = "Name to be used on all resources as prefix"
  default     = "test"
}

variable "environment" {
  description = "Environment for service"
  default     = "dev"
}

variable "orchestration" {
    description = "Type of orchestration"
    default     = "Terraform"
}

variable "createdby" {
    description = "Created by"
    default     = "uglykoyote"
}

variable "allowed_ports" {
    description = "Allowed ports from/to host"
    type        = "list"
    default     = ["80", "8080"]
}

variable "public_subnet_cidrs" {
    description = "CIDR for the Public Subnet"
    type        = "list"
    default     = []
}

variable "availability_zone" {
	description = "The AZ for the subnet"
    type		= "list"
	default     = []
}

variable "private_subnet_cidrs" {
    description = "CIDR for the Private Subnet"
    type        = "list"
    default     = ["use1-az1", "use1-az2"]
}

variable "availability_zones" {
    description = "A list of Availability zones in the region"
    type        = "list"
    default     = ["use1-az1", "use1-az2"]
}

variable "public_cidr_block" {
    type        = "list"
    default     = ["172.32.1.0/24", "172.32.3.0/24"]
}

variable "private_cidr_block" {
    type        = "list"
    default     = ["172.32.2.0/24", "172.32.4.0/24"]
}

variable "enable_internet_gateway" {
    description = "Allow Internet GateWay to/from public network"
    default     = "false"
}
