variable "lb_target_group_name" {
    description = "The name of the load balancer target group"
}

variable "lb_target_group_port" {
    description = "The port on which the target group is listening"
}

variable "lb_target_group_protocol" {
    description = "The protocol used by the target group (HTTP/HTTPS)"
}

variable "vpc_id" {
    description = "The VPC ID where the target group is created"
}

variable "ec2_instance_id" {
    description = "The EC2 instance ID to attach to the target group"
}

output "dev_proj_1_lb_target_group_arn" {
    value = aws_lb_target_group.dev_proj_1_lb_target_group.arn
}

resource "aws_lb_target_group" "dev_proj_1_lb_target_group" {
    name     = var.lb_target_group_name
    port     = var.lb_target_group_port
    protocol = var.lb_target_group_protocol
    vpc_id   = var.vpc_id

    health_check {
        path                = "/login"
        port                = var.lb_target_group_port
        healthy_threshold   = 6
        unhealthy_threshold = 2
        timeout             = 2
        interval            = 5
        matcher             = "200"  # HTTP 200 response
    }
}

resource "aws_lb_target_group_attachment" "dev_proj_1_lb_target_group_attachment" {
    target_group_arn = aws_lb_target_group.dev_proj_1_lb_target_group.arn
    target_id        = var.ec2_instance_id
    port             = var.lb_target_group_port
}