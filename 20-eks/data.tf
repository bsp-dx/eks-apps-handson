data "aws_vpc" "this" {
  filter {
    name   = "tag:Name"
    values = ["${local.name_prefix}-vpc"]
  }
}

data "aws_subnet_ids" "subnets" {
  vpc_id = data.aws_vpc.this.id
  filter {
    name   = "tag:kubernetes.io/cluster/${module.eks.cluster_name}"
    values = ["shared"]
  }
}

data "aws_subnet_ids" "public" {
  vpc_id = data.aws_vpc.this.id
  filter {
    name   = "tag:kubernetes.io/role/elb"
    values = ["1"]
  }
}

data "aws_subnet_ids" "web" {
  vpc_id = data.aws_vpc.this.id
  filter {
    name   = "tag:kubernetes.io/role/internal-elb"
    values = ["1"]
  }
  filter {
    name   = "tag:Name"
    values = [ format("%s-web*", local.name_prefix) ]
  }
}

data "aws_subnet_ids" "api" {
  vpc_id = data.aws_vpc.this.id

  filter {
    name   = "tag:kubernetes.io/role/internal-elb"
    values = ["1"]
  }

  filter {
    name   = "tag:Name"
    values = [ format("%s-api*", local.name_prefix) ]
  }

}

data "aws_ami" "amazon-linux2-x86" {
  owners = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amazon-eks-node-1.21*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

}
