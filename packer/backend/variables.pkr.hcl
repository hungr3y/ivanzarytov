variable "access_key" {
  type        = string
  default     = ""
  description = "Access key to AWS"
  sensitive   = true
}

variable "secret_key" {
  type        = string
  default     = ""
  description = "Secret key to AWS"
  sensitive   = true
}

variable "ssh_username" {
  type        = string
  default     = "ec2-user"
  description = "Username for ssh connection to node"
}

variable "region" {
  type        = string
  default     = "eu-central-1"
  description = "AWS region, for example eu-central-1 (Frankfurt)"
}

variable "copy_regions" {
  type    = list(string)
  default = [
    "eu-west-1",
    "eu-west-3",
    "us-east-1",
    "us-east-2",
    "ap-northeast-1"
  ]
  description = "Regions where created AMI will be copied"
}

variable "vpc_id" {
  type        = string
  default     = "vpc-a0a0a0a0a0a0a0a0a0a0"
  description = "VPC for AMI creation"
}

variable "subnet_id" {
  type        = string
  default     = "subnet-b1b1b1b1b1b1b1b1b"
  description = "Subnet for AMI creation"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "AWS instance type, for example m6i.xlarge"
}

variable "docker_mirror" {
  type        = string
  default     = "test.aws.ecr"
  description = "Url to AWS ECR"
}

variable "force_deregister" {
  type        = bool
  default     = false
  description = "Force deregister existing AMI with the same name"
}

variable "skip_create_ami" {
  type        = bool
  default     = false
  description = "Skip AMI creation"
}

variable "ami_name" {
  type        = string
  default     = "Al2023-DefaultAmi"
  description = "Default AMI name"
}
