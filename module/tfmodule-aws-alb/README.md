# tfmodule-aws-alb

AWS Applicatoin 또는 Network Load Balancer 인스턴스를 생성하는 테라폼 모듈 입니다.

## Example

```
module "ctx" {
  source = "../context"
}

data "aws_acm_certificate" "this" {
  domain = module.ctx.domain
}

data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = ["${module.ctx.name_prefix}-vpc"]
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.this.id
  filter {
    name   = "tag:kubernetes.io/role/elb"
    values = ["1"]
  }
}

resource "aws_security_group" "alb" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = data.aws_vpc.this.id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      =  ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = merge(module.ctx.tags, {Name = "${module.ctx.name_prefix}-alb-sg"})
}


module "alb" {
  source = "../tfmodule-aws-alb"

  context  = module.ctx.context
  load_balancer_type = "application"

  vpc_id          = data.aws_vpc.this.id
  security_groups = [ aws_security_group.alb.id ]
  subnets         = data.aws_subnet_ids.public.ids

  target_groups = [
    {
      name                 = "user-tg8010"
      protocol_version      = "HTTP1"
      backend_protocol     = "HTTP"
      backend_port         = 8010
      target_type          = "instance"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        path                = "/api/user/health"
        port                = "traffic-port"
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 6
        interval            = 20
        protocol            = "HTTP"
        matcher             = "200-201"
      }
    },
    {
      name                 = "order-tg8080"
      backend_protocol     = "HTTP"
      backend_port         = 8080
      target_type          = "instance"
      health_check = {
        path                = "/api/order/health"
        protocol            = "HTTP"
      }
      #      targets = {
      #        order1_ec2 = {
      #          target_id = aws_instance.order.id
      #          port      = 8080
      #        },
      #        order2_ec2 = {
      #          target_id = aws_instance.order2.id
      #          port      = 8080
      #        }
      #      }
      #      tags = {
      #        InstanceTargetGroupTag = "baz"
      #      }
    },
  ]


  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = data.aws_acm_certificate.this.arn
      target_group_index = 0
    }
  ]

  https_listener_rules = [
    {
      https_listener_index = 0
      priority             = 1
      actions = [
        {
          type               = "forward"
          target_group_index = 0
        }
      ]
      conditions = [{
        path_patterns = ["/api/v2/users"]
      }]
    },
    {
      https_listener_index = 0
      priority             = 2
      actions = [
        { type = "forward", target_group_index = 1}
      ]
      conditions = [{
        http_headers = [{
          http_header_name = "X-Route-Path"
          values           = ["order", "order1", "order2"]
        }]
      }]
    },
    {
      https_listener_index = 0
      priority             = 3
      actions = [
        { type = "forward", target_group_index = 1}
      ]
      conditions = [{
        host_headers = [ format("order.%s", module.ctx.domain) ]
      }]
    },
    {
      https_listener_index = 0
      priority             = 4
      actions = [{
        type = "weighted-forward"
        target_groups = [
          {
            target_group_index = 0
            weight             = 3
          },
          {
            target_group_index = 1
            weight             = 7
          }
        ]
        stickiness = {
          enabled  = true
          duration = 3600
        }
      }]
      conditions = [{
        http_headers = [{
          http_header_name = "X-Route-Path"
          values           = ["home", "index"]
        }]
      }]
    },
  ]

  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    },
  ]

  # ...
}
```

## Input Variables

| Name | Description | Type | Example | Required |
|------|-------------|------|---------|:--------:|
| name | description | type | example | required |
### Variables Reference


## Output

| Name | Description | Example |
|------|-------------|---------|
| name | description | example |