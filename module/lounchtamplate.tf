resource "aws_launch_template" "launch-t" {
  name_prefix   = "launch-t"
  image_id      = "ami-0e472ba40eb589f49" #data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = var.keyname
  vpc_security_group_ids = ["${aws_security_group.ec2.id}"]
  user_data =  base64encode(data.template_file.capstone-terraform.rendered)
  depends_on = [
    github_repository_file.dbendpoint,
    aws_instance.nat,
    aws_iam_role.capstone_some_role,
    aws_iam_instance_profile.capstone_some_profile,
    aws_db_instance.capstone_rds]
  iam_instance_profile {
    name = aws_iam_instance_profile.capstone_some_profile.id
  }
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "aws_capstone_web_server"
    }
}
}

resource "github_repository_file" "dbendpoint" {
  content = aws_db_instance.capstone_rds.address
  file = "src/dbserver.endpoint"
  repository = "aws-capstone-terraform-project"
  overwrite_on_create = true
  branch = "main"
}

data "template_file" "capstone-terraform" {
  template = "${file("${path.module}/userdata.sh")}"
  vars = {
    user-data-git-token = var.git-token
    user-data-git-name = var.git-name
  }
}



output "address" {
  value       = aws_db_instance.capstone_rds.address
  description = "Connect to the database at this endpoint"
}


# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-20221201"]
#   }

#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }

#   owners = ["amazon"] # Canonical
# }

# output "name" {
#   value = data.aws_ami.ubuntu.id
# }
