# ECS with Terraform

ECS has a lot of moving parts. You have to have the right security groups, you have to have load balancers, ec2 instances (either as part of an ASG or not), among other things.

So as not to redo hard work, I found [arminc's repo](https://github.com/arminc/terraform-ecs) a great resource. You can either use arminc's terraform module directly, or look at his code and cherrypick what you need.



### Deploying ECS Services

One thing arminc does not have the terraform for is deploying ECS services and tasks. Terraform AWS does provide service and task definition resources. 

The `modules/ecs-service` directory contains code for deploying a simple one container service. Extend it as you need.