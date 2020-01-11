

resource "aws_security_group" "rds_security" {
  name        = "${var.server_name}-rds-security-group"
  description = "Allow mysql port connections ingress. Allow egress on all ports."

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8", "100.0.0.0/8"] # allow only ingress from inside the cloud VPC
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    {
      "Name" = "${var.server_name} Database"
    }
  )
}

###########################################
# Decrypting Secrets
#    You could pass the database password
# in plain text to the aws_rds_cluster resource
# below. This has serious security implecations
# because it will show up in plain text in the
# state file and in logs. It is better to
# encrypt it using KMS, then decrypt it here
# in the terraform
###########################################
data "aws_kms_secrets" "db_credentials" {
  secret {
    name = "password"
    payload = var.encrypted_db_root_password
  }
}

resource "aws_rds_cluster" "webserver_database_cluster" {
  cluster_identifier = "${var.server_name}-rds-cluster"

  engine         = var.db_engine
  engine_version = var.db_version

  master_username = "root"
  master_password = data.aws_kms_secrets.db_credentials.plaintext["password"] # The "password" key here should match the secret name on line 41

  vpc_security_group_ids = split(",", aws_security_group.rds_security.id)

  tags = merge(var.tags, {
    "Name" = "${var.server_name} Database"
  })
}

resource "aws_rds_cluster_instance" "webserver_database_cluster" {
  
}
