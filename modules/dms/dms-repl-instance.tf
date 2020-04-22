# Create an endpoint for the target database
resource "aws_dms_endpoint" "source" {
  database_name = var.source_db_name
  endpoint_id   = "${var.stack_name}-dms-${var.environment}-source"
  endpoint_type = "source"
  engine_name   = var.source_engine_name
  password      = var.source_app_password
  port          = var.source_db_port
  server_name   = aws_db_instance.source.address
  ssl_mode      = "none"
  username      = var.source_app_username

  tags {
    Name        = "${var.stack_name}-dms-${var.environment}-source"
    owner       = var.owner
    stack_name  = var.stack_name
    environment = var.environment
    created_by  = "terraform"
  }
}

# Create an endpoint for the target database

resource "aws_dms_endpoint" "target" {
  database_name = var.target_db_name
  endpoint_id   = "${var.stack_name}-dms-${var.environment}-target"
  endpoint_type = "target"
  engine_name   = var.target_engine
  password      = var.target_password
  port          = var.target_db_port
  server_name   = aws_db_instance.target.address
  ssl_mode      = "none"
  username      = var.target_username

  tags {
    Name        = "${var.stack_name}-dms-${var.environment}-target"
    owner       = var.owner
    stack_name  = var.stack_name
    environment = var.environment
    created_by  = "terraform"
  }
}

# Create a subnet group using existing VPC subnets
resource "aws_dms_replication_subnet_group" "dms" {
  replication_subnet_group_description = "DMS replication subnet group"
  replication_subnet_group_id          = "dms-replication-subnet-group-tf"
  //   subnet_ids = [aws_subnet.database.*.id]
}

# Create a new DMS replication instance
resource "aws_dms_replication_instance" "link" {
  allocated_storage            = var.replication_instance_storage
  apply_immediately            = true
  auto_minor_version_upgrade   = true
  availability_zone            = var.availability_zones[count.index]
  engine_version               = var.replication_instance_version
  multi_az                     = false
  preferred_maintenance_window = var.replication_instance_maintenance_window
  publicly_accessible          = false
  replication_instance_class   = var.replication_instance_class
  replication_instance_id      = "dms-replication-instance-tf"
  replication_subnet_group_id  = aws_dms_replication_subnet_group.dms.id

  vpc_security_group_ids = [aws_security_group.rds.id]

  tags {
    Name        = "${var.stack_name}-dms-${var.environment}-${var.availability_zones[count.index]}"
    owner       = var.owner
    stack_name  = var.stack_name
    environment = var.environment
    created_by  = "terraform"
  }
}

# Create a new DMS replication task
resource "aws_dms_replication_task" "dblink" {
  migration_type = "full-load"

  #replication_instance_arn = "${aws_dms_replication_instance.link.replication_instance_arn}"
  replication_instance_arn = var.replication_instance_arn
  replication_task_id      = var.replication_task_id
  source_endpoint_arn      = var.dms_source_arn
  table_mappings           = data.template_file.table_mappings.rendered
  target_endpoint_arn      = var.dms_target_arn

  tags {
    Name        = "${var.stack_name}-dms-${var.environment}-replication-task"
    owner       = var.owner
    stack_name  = var.stack_name
    environment = var.environment
    created_by  = "terraform"
  }
}

