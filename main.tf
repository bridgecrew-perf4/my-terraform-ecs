provider "aws" {
  region = "${var.aws-region}"
  shared_credentials_file = "~/.aws/credentials"
}

module "aws_vpc" {
    source                              = "./modules/vpc"
    name                                = "cloudx"
    environment                         = "test"
    vpc_cidr                            = "10.10.0.0/16"
    availability_zone			        = ["use1-az1", "use1-az2", "use1-az3"]
    enable_internet_gateway		        = "true"

}

module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 3.0"
}