data "aws_ecs_cluster" "cluster" {
  cluster_name = var.cluster_name
}

resource "aws_ecs_task_definition" "task" {
  family                = var.name
  container_definitions = "${file("task-definitions/service.json")}"

  cpu = var.cpu
  memory = var.memory

  volume {
    name      = "storage-name"
    host_path = "/mnt/${var.task_name}"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [${join(", ", var.task_azs)}]"
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
    container_name   = "mongo"
    container_port   = 8080
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [${join(", ", var.task_azs)}]"
  }
}

