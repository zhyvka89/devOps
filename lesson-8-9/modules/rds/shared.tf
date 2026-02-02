resource "aws_security_group" "db" {
  name   = "${var.name}-db-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_db_parameter_group" "this" {
  count  = var.use_aurora ? 0 : 1
  family = "${var.engine}${substr(var.engine_version, 0, 1)}"
  name   = "${var.name}-pg"

  parameter {
    name  = "max_connections"
    value = "200"
  }

  parameter {
    name  = "log_statement"
    value = "all"
  }

  parameter {
    name  = "work_mem"
    value = "65536"
  }
}
