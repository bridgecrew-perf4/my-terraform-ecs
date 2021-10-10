module "myip" {
  source  = "4ops/myip/http"
  version = "1.0.0"
}

resource "aws_vpc" "aws_vpc" {
    cidr_block                          = "${var.vpc_cidr}"
    instance_tenancy                    = "default"
    enable_dns_support                  = "true"
    enable_dns_hostnames                = "true"
    assign_generated_ipv6_cidr_block    = "false"
    enable_classiclink                  = "false"

    tags = {
      Name = "${var.name}-${var.environment}-${var.vpc_name}"
    }
}

resource "aws_internet_gateway" "default" {
	vpc_id = "${aws_vpc.aws_vpc.id}"

	tags = {
        Name            = "${var.igw_name}"
        Environment     = "${var.environment}"
        Orchestration   = "${var.orchestration}"
        Createdby       = "${var.createdby}"
    }

	depends_on  = ["aws_vpc.aws_vpc"]
}

resource "aws_route_table" "public_rt" {
  vpc_id = "${aws_vpc.aws_vpc.id}"
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.default.id}"
  }

    tags = {
        Name            = "public_rt"
        Environment     = "${var.environment}"
        Orchestration   = "${var.orchestration}"
        Createdby       = "${var.createdby}"
    }

   depends_on  = ["aws_internet_gateway.default"]

}

resource "aws_route_table" "private_rt" {
  vpc_id = "${aws_vpc.aws_vpc.id}"

    tags = {
        Name            = "private_rt"
        Environment     = "${var.environment}"
        Orchestration   = "${var.orchestration}"
        Createdby       = "${var.createdby}"
    }

   depends_on  = ["aws_route_table.public_rt"]

}

resource "aws_security_group" "vpc_endpoint" {
    name                = "vpc_endpoint"
    description         = "Defines access to vpc endpoints"
    vpc_id              = "${aws_vpc.aws_vpc.id}"

    tags = {
        Name            = "${var.name}-vpc_endpoint-${var.environment}"
        Environment     = "${var.environment}"
        Orchestration   = "${var.orchestration}"
        Createdby       = "${var.createdby}"
    }
    lifecycle {
        create_before_destroy = true
    }
    ingress {
        description = "Ingress for vpc_endpoint"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["${var.vpc_cidr}"]
        prefix_list_ids  = []
        security_groups  = []
        ipv6_cidr_blocks = []
        self = false
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    depends_on  = ["aws_vpc.aws_vpc"]
}

resource "aws_security_group" "alb" {
    name                = "alb"
    description         = "Defines access to alb"
    vpc_id              = "${aws_vpc.aws_vpc.id}"

    tags = {
        Name            = "${var.name}-alb-${var.environment}"
        Environment     = "${var.environment}"
        Orchestration   = "${var.orchestration}"
        Createdby       = "${var.createdby}"
    }
    lifecycle {
        create_before_destroy = true
    }

    depends_on  = ["aws_vpc.aws_vpc"]
}

resource "aws_security_group" "efs" {
    name                = "efs"
    description         = "Defines access to efs mount points"
    vpc_id              = "${aws_vpc.aws_vpc.id}"

    tags = {
        Name            = "${var.name}-efs-${var.environment}"
        Environment     = "${var.environment}"
        Orchestration   = "${var.orchestration}"
        Createdby       = "${var.createdby}"
    }
    lifecycle {
        create_before_destroy = true
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["${var.vpc_cidr}"]
    }
    
    depends_on  = ["aws_vpc.aws_vpc"]
}

resource "aws_security_group" "mysql" {
    name                = "mysql"
    description         = "Defines access to ghost db"
    vpc_id              = "${aws_vpc.aws_vpc.id}"

    tags = {
        Name            = "${var.name}-mysql-${var.environment}"
        Environment     = "${var.environment}"
        Orchestration   = "${var.orchestration}"
        Createdby       = "${var.createdby}"
    }
    lifecycle {
        create_before_destroy = true
    }

    depends_on  = ["aws_vpc.aws_vpc"]
}

resource "aws_security_group" "fargate_pool" {
    name                = "fargate_pool"
    description         = "Allows access for fargate instances"
    vpc_id              = "${aws_vpc.aws_vpc.id}"

    tags = {
        Name            = "${var.name}-fargate_pool-${var.environment}"
        Environment     = "${var.environment}"
        Orchestration   = "${var.orchestration}"
        Createdby       = "${var.createdby}"
    }
    lifecycle {
        create_before_destroy = true
    }
    ingress = [
        {
            description = "Ingress for fargate_pool"
            from_port   = 2049
            to_port     = 2049
            protocol    = "tcp"
            cidr_blocks = ["${var.vpc_cidr}"]
            prefix_list_ids  = []
            security_groups  = []
            ipv6_cidr_blocks = []
            self = false
        },
    ]
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    depends_on  = ["aws_vpc.aws_vpc"]
}

resource "aws_security_group" "ec2_pool" {
    name                = "ec2_pool"
    description         = "Allows access for ec2 instances"
    vpc_id              = "${aws_vpc.aws_vpc.id}"

    tags = {
        Name            = "${var.name}-ec2_pool-${var.environment}"
        Environment     = "${var.environment}"
        Orchestration   = "${var.orchestration}"
        Createdby       = "${var.createdby}"
    }
    lifecycle {
        create_before_destroy = true
    }
    ingress = [
        {
            description = "Ingress for ec2_pool_sg"
            from_port   = 22
            to_port     = 22
            protocol    = "tcp"
            cidr_blocks = ["${module.myip.address}/32"]
            prefix_list_ids  = []
            security_groups  = []
            ipv6_cidr_blocks = []
            self = false
        },
        {
            description = "Ingress for ec2_pool_sg"
            from_port   = 2049
            to_port     = 2049
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"] 
            prefix_list_ids  = []
            security_groups  = []
            ipv6_cidr_blocks = []
            self = false
        }
    ]
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    depends_on  = ["aws_vpc.aws_vpc"]
}

resource "aws_security_group_rule" "ec2_pool_to_alb" {
    type                = "ingress"
    description         = "Ingress from e2c_pool to alb"
    security_group_id   = "${aws_security_group.ec2_pool.id}"
    source_security_group_id = "${aws_security_group.alb.id}"
    from_port           = 2368
    to_port             = 2368
    protocol            = "tcp"
}

resource "aws_security_group_rule" "fargate_to_alb" {
    type                = "ingress"
    description         = "Ingress from fargate_pool to alb"
    security_group_id   = "${aws_security_group.fargate_pool.id}"
    source_security_group_id = "${aws_security_group.alb.id}"
    from_port           = 2368
    to_port             = 2368
    protocol            = "tcp"
}

resource "aws_subnet" "public_subnet" {
    count               = "${length(var.availability_zone)}"
    vpc_id 		        = "${aws_vpc.aws_vpc.id}"
    cidr_block          = "${element(var.public_cidr_block, count.index)}"
	availability_zone_id	= "${element(var.availability_zone, count.index)}"

    tags = {
		Name            = "${element(var.public_subnet_name, count.index)}"
        Environment     = "${var.environment}"
        Orchestration   = "${var.orchestration}"
        Createdby       = "${var.createdby}"
    }

    depends_on  = ["aws_vpc.aws_vpc"]
}

resource "aws_subnet" "private_subnet" {
	count               = "${length(var.availability_zone)}"
    vpc_id              = "${aws_vpc.aws_vpc.id}"
	cidr_block          = "${element(var.private_cidr_block, count.index)}"
    availability_zone_id   = "${element(var.availability_zone, count.index)}"

    tags = {
        Name            = "${element(var.private_subnet_name, count.index)}"
        Environment     = "${var.environment}"
        Orchestration   = "${var.orchestration}"
        Createdby       = "${var.createdby}"
    }

    depends_on  = ["aws_vpc.aws_vpc"]
}

resource "aws_subnet" "db_private_subnet" {
	count               = "${length(var.availability_zone)}"
    vpc_id              = "${aws_vpc.aws_vpc.id}"
	cidr_block          = "${element(var.db_cidr_block, count.index)}"
    availability_zone_id   = "${element(var.availability_zone, count.index)}"

    tags = {
        Name            = "${element(var.private_db_subnet_name, count.index)}"
        Environment     = "${var.environment}"
        Orchestration   = "${var.orchestration}"
        Createdby       = "${var.createdby}"
    }

    depends_on  = ["aws_vpc.aws_vpc"]
}

resource "aws_route_table_association" "a" {
	count          = "${length(var.public_cidr_block)}"
	subnet_id      = "${element(aws_subnet.public_subnet.*.id,count.index)}"
	route_table_id = "${aws_route_table.public_rt.id}"
}

resource "aws_route_table_association" "b" {
	count          = "${length(var.private_cidr_block)}"
	subnet_id      = "${element(aws_subnet.private_subnet.*.id,count.index)}"
	route_table_id = "${aws_route_table.private_rt.id}"
}