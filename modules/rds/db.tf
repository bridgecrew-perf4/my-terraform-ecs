resource "db_subnet_group" {

    description     =   'Ghost database subnet group'
    default         = "${var.db.identifier}"

    subnet_ids      = "${element(aws_subnet.db_private_subnet.*.id,count.index)}"

}

resource "db_instance" {
    identifier          = "${var.db.identifier}"
    allocated_storage   = "${var.db.allocated_storage}"
    storage_type        = "${var.db.storage_type}"

    vpc_security_group_ids = "${element(aws_security_group.mysql.*.id,count.index)}"

    depends_on          = [db_subnet_group]
}