terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.12.31"
}

provider "aws" {
  profile = "default"
  region  = "eu-west-2"
}

module "vpc" {
  source = "./modules/vpc"
  env    = "devops_course"
}

resource "aws_instance" "app_server" {
  ami           = "ami-xxxxxx"
  instance_type = "t2.micro"

  tags = {
    Name = "EC2DevOpsCourse"
  }
}

module "web_instance" {
  source    = "./modules/ec2"
  subnet_id = module.vpc.vpc_id
  sg_ids    = [module.vpc.public_sg_id]
  name      = "web"
  key_name  = "devops_course"
}