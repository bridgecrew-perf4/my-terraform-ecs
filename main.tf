provider "aws" {
  region = "${var.aws-region}"
  shared_credentials_file = "~/.aws/credentials"
}

module "iam" {
    source                              = "./modules/iam"
    name                                = "myEC2"
    environment                         = "test"
}

module "aws_vpc" {
    source                              = "./modules/vpc"
    name                                = "my-vpc"
    environment                         = "test"
    vpc_cidr                            = "172.32.0.0/16"
	public_cidr_block					= ["172.32.1.0/24", "172.32.3.0/24"]
	private_cidr_block					= ["172.32.2.0/24", "172.32.4.0/24"]
    allowed_ports                       = ["80", "443", "8080", "8443"]
	availability_zone					= ["use1-az1", "use1-az2"]
    enable_internet_gateway				= "true"
}

module "ecs" {
	source                              = "./modules/ecs"
	name								= "my-ecs"
	ecs-cluster-name					= "ec2-cluster"
	environment                         = "test"
}

module "ec2" {
    source                              = "./modules/ec2"
    name                                = "myEC2"
    environment                         = "test"
    vpc_security_group_ids              = ["${module.aws_vpc.security_group_id}"]
    subnet_id                           = "${module.aws_vpc.publicsubnet_id_0}"
    key_path                            = "/root/.ssh/id_rsa.pub"
    iam_instance_profile                = "${module.iam.iam-profile-name}"
    ecs_cluster		                    = "${module.ecs.ecs_cluster_name}"
}

output "connection-string" {
	value = module.ec2.ec2_public_ip
}
