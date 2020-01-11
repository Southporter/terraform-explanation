variable "aws_vpc" {}
variable "dns_zone" {}
variable "dns_subdomain" {}
variable "dns_ttl" {
  default = 60
}
variable "is_private" {
  default = false
}

variable "server_name" {}

variable "encrypted_db_root_password" { }
variable "db_engine" {
  default = "aurora-mysql"
}
variable "db_version" {
  default = "5.7.mysql_aurora.2.03.2"
}
variable "db_instance" {
  default = "db.m4.large"
}

variable "instance_type" {
  default = "m4.large"
}

variable "tags" {
  type = "map"
}


