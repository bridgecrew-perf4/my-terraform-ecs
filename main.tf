provider "aws" {
#   region = "${var.aws-region}"
  region  = "us-east-1"
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

module "rds" {
    source  = "terraform-aws-modules/rds/aws"
    # source  = "./modules/rds"

    identifier              = "ghost"
    engine                  = "mysql"
    engine_version          = "8.0.20"
    family                  = "mysql8.0" # DB parameter group
    major_engine_version    = "8.0"      # DB option group
    instance_class          = "db.t2.micro"
    skip_final_snapshot     = true
    auto_minor_version_upgrade  = false

    allocated_storage       = 20
    storage_type            = "gp2"
}