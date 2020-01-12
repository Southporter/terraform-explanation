###########################################################
# There are two ways to handle the ecs cluster. Either way,
# we are supposing here that the cluster has already been
# created. Using the aws_ecs_cluster data object here allows
# us to put the services into the cluster regardles of
# whether the cluster was created in another terraform file
# or manually via the console. As long as we have the name,
# we can put services into the cluster.
##########################################################
data "aws_ecs_cluster" "cluster" {
  cluster_name = var.cluster_name
}

data "template_file" "container_definitions" {
  template = "${file("${path.module}/container.json")}"
  vars = merge({
    "name" = var.name
  },var.container_vars)
}

resource "aws_ecs_task_definition" "task" {
  family                = var.name
  container_definitions = "${data.template_file.container_definitions.rendered}"

  cpu = var.cpu
  memory = var.memory

  volume {
    name      = "storage-name"
    host_path = "/mnt/${var.name}"
  }

  placement_constraints {
    "type": "distinctInstance" # Puts only one container on an instance
  }
}

resource "aws_ecs_service" "service" {
  name            =  var.name
  cluster         = "${data.aws_ecs_cluster.cluster.id}"
  task_definition = "${aws_ecs_task_definition.task.arn}"
  desired_count   = var.desired_count
  iam_role        = var.role

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = "${aws_lb_target_group.foo.arn}"
    container_name   = var.container_name
    container_port   = var.container_port
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [${join(", ", var.task_azs)}]"
  }
}

