packer {
  required_plugins {
    amazon = {
      version = "1.3.2"
      source  = "github.com/hashicorp/amazon"
    }
    ansible = {
      version = "1.1.1"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

locals {
  timestamp = formatdate("YYYY-MM-DD", timestamp())
}

source "amazon-ebs" "amazon-linux" {

  #Debug configuration
  skip_create_ami  = var.skip_create_ami
  force_deregister = var.force_deregister

  #Access configuration
  access_key           = var.access_key
  secret_key           = var.secret_key
  region               = var.region
  iam_instance_profile = "s3-ecr-ro-packer"

  #AMI configuration
  ami_name        = var.ami_name
  ami_description = "Default AMI for backend and GSM - ${local.timestamp}"
  ami_regions     = var.copy_regions
  instance_type   = var.instance_type
  source_ami_filter {
    filters = {
      name                = "al2023*hvm*x86_64"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }

  #Run configuration
  vpc_id        = var.vpc_id
  subnet_id     = var.subnet_id
  ssh_username  = var.ssh_username
  ssh_interface = "private_ip"

}

build {
  name    = "amazon-linux-build"
  sources = [
    "source.amazon-ebs.amazon-linux"
  ]

  provisioner "ansible" {
    user             = var.ssh_username
    playbook_file    = "${path.cwd}/ansible/playbooks/bootstrap/setup.yml"
    roles_path       = "${path.cwd}/ansible/roles"
    ansible_env_vars = ["ANSIBLE_CONFIG=${path.cwd}/ansible/ansible.cfg"]
    extra_arguments  = ["--extra-vars", "docker_mirror=${var.docker_mirror}"]
  }
}