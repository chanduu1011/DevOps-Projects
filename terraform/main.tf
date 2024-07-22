terraform{
    required_providers {
      aws={
        source ="hashicorp/aws"
        version="~>4.0"
      }
    }
    backend "s3" {
        key="aws/ec2-deploy/terraform.tfstate"
      
    }
}
provider "aws" {
    region=var.region

  
}
resource "aws_instance" "name" {
    ami="ami-04a81a99f5ec58529 "
    instance_type = "t2.micro"
    key_name = aws_key_pair.deployer.key_name
    vpc_security_group_ids = [aws_security_group.sgroup.id]
    iam_instance_profile = aws_iam_instance_profile.ec2_profile.name

    connection {
      type="ssh"
      host = self.public_ip
      user = "ubuntu"
      private_key = var.private_key
      timeout = "4m"

    }
    tags = {
      "name"="Deployed"
    }
  
}
resource "aws_iam_instance_profile" "ec2_profile" {
    name="ec2-profile"
    role="ec2-ecr-auth"
  
}
resource "aws_security_group" "sgroup" {
    egress = [
        {
            cidr_blocks=["0.0.0.0/0"]
            description = ""
            from_port = 0
            ipv6_cidr_blocks = []
            prefix_list_ids = []
            protocol = "-1"
            security_groups = []
            self=false
            to_port = 0

        }
    ]
    ingress= [
        {
            cidr_blocks=["0.0.0.0/0",]
            description = ""
            from_port = 22
            ipv6_cidr_blocks = []
            prefix_list_ids = []
            protocol = "tcp"
            security_groups = []
            self=false
            to_port = 22


        },
        {
            cidr_blocks=["0.0.0.0/0",]
            description = ""
            from_port = 90
            ipv6_cidr_blocks = []
            prefix_list_ids = []
            protocol = "tcp"
            security_groups = []
            self=false
            to_port = 90


        }
    ]
        
    
  
}
resource "aws_key_pair" "deployer" {
    key_name=var.key_name
    public_key = var.public_key
  
}
output "instance_publicip" {
    value = aws_instance.sever.public_ip

  
}