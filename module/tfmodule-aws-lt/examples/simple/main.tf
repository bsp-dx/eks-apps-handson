data "aws_ami" "my_web" {

  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-*"]
  }

}

# 커스텀 user_data
data "template_file" "my_web" {
  template = file("${path.module}/templates/my-web.tpl")
  vars     = {
    name = "Symplesims"
  }
}

# Launch Template
module "my_web" {
  source = "../../"

  context          = var.context
  image_id         = data.aws_ami.my_web.id
  instance_type    = "t3.small"
  name             = "my_web"
  user_data_base64 = base64encode(data.template_file.my_web.rendered)

}