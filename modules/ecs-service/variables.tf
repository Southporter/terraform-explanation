variable "cluster_name" {}
variable "container_vars" {
  type = "map(string)"
  description = <<EOD
Container vars need the following:
  image:  The container image, either from docker hub, ecr, or another compatible repository
  containerHttpPort
  hostHttpPort
  containerHttpsPort
  hostHttpsPort
  command: The command to be run inside the container
EOD
}

variable "name" {
  description = "The name of the service/task"
}

variable "cpu" {
  default = 0.5
}

variable "memory" {
  default = 700 #MiB
}

variable "desired_count" {
  default = 2
}

variable "role" {
  description = "The role ARN used by the service. Should have all the permissions your container(s) needs to run."
}

variable "container_name" {}
variable "container_port" {}
