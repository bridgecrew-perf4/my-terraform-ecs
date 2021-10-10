variable "vpc_cidr" {
  description = "My vpc cidr"
  default = "10.0.0.0/16"
}

variable "igw_name" {
    description = "My CloudX IGW"
    default = "cloudx-igw"
}

variable "vpc_name" {
  description = "My vpc name"
  default = "cloudx"
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
    type        = list(string)
    default     = ["80", "8080"]
}

variable "public_subnet_cidrs" {
    description = "CIDR for the Public Subnet"
    type        = list(string)
    default     = []
}

variable "availability_zone" {
	description = "The AZ for the subnet"
    type		= list(string)
	default     = []
}

variable "availability_zones" {
    description = "A list of Availability zones in the region"
    type        = list(string)
    default     = ["use1-az1", "use1-az2", "use1-az3"]
}

variable "public_cidr_block" {
    type        = list(string)
    default     = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
}

variable "public_subnet_name" {
    description = "Public subnet name"
    type        = list(string)
    default     = ["public_a", "public_b", "public_c"]
}

variable "private_cidr_block" {
    type        = list(string)
    default     = ["10.10.10.0/24", "10.10.11.0/24", "10.10.12.0/24"]
}

variable "private_subnet_name" {
    description = "Private subnet name"
    type        = list(string)
    default     = ["private_a", "private_b", "private_c"]
}

variable "db_cidr_block" {
    type        = list(string)
    default     = ["10.10.20.0/24", "10.10.21.0/24", "10.10.22.0/24"]
}

variable "private_db_subnet_name" {
    description = "Private db subnet name"
    type        = list(string)
    default     = ["private_db_a", "private_db_b", "private_db_c"]
}

variable "enable_internet_gateway" {
    description = "Allow Internet GateWay to/from public network"
    default     = "false"
}
