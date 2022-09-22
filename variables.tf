variable "solution_details" {
  type = map
    default = {
    app_name = "de-media-proxy"
    aws_account = "299832127815" # strategy-lab (299832127815) | disteng-mc-production (790723743577)
    env = "dev"
    region = "us-east-1"
  }
}

variable "common_app_tags" {
  default     = {
    application = "myapp"
    owner = "de-engineering"
    env = "dev"
  }
  description = "Common tag shared across application resource."
  type        = map(string)
}

variable "amis" {
  type = map
    default = {
      windows2019 = "ami-09893189de3a034b4"
      amznlinux2 = "ami-0022f774911c1d690"
      ubuntu = "ami-09d56f8956ab235b3"
      centos7 = "ami-0001378efdafd5401"
      rhel7 = "ami-029c0fbe456d58bd1"
      oracle7 = "ami-002c51f3380aa2fad"
  }
}

variable "shared_ec2_vars" {
    type = map
    default = {
    region = "us-east-1"
    vpc = "vpc-03e187554457a5b57"
    subnet = "subnet-0d214ae812cbf6518"
    subnetroutingtable = "rtb-028b68561ead8295d"
    ec2type = "t2.xlarge"
    publicip = false
    keyname = "asim-test"
    secgroupname = "ssm-poc-test-sg"
    secgroupid = "sg-046613779e5fef592"
    ec2profile = "asim-test-ssm-role"
  }
}

# AWS AZ
variable "aws_az" {
  type        = string
  description = "AWS AZ"
  default     = "us-east-1a"
}

# VPC Variables
variable "vpc_cidr" {
  type        = string
  description = "CIDR for the VPC"
  default     = "10.1.64.0/18"
}

# Subnet Variables
variable "public_subnet_cidr" {
  type        = string
  description = "CIDR for the public subnet"
  default     = "10.1.64.0/24"
}

# Subnet Variables
variable "private_subnet_cidr" {
  type        = string
  description = "CIDR for the public subnet"
  default     = "10.1.65.0/24"
}


# var assignment options:
# instance_type = lookup(var.ec2vars, "ec2type")
# instance_type = var.ec2vars["ec2type"]