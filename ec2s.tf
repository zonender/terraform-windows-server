
####################################################
####################################################
# MEDIA PROXY WINDOWS EC2
####################################################
####################################################

# EC2:
####################################################

resource "aws_instance" "media_proxy_ec2" {
  instance_type = var.shared_ec2_vars["ec2type"]
  ami = var.amis["windows2019"]
  subnet_id = var.shared_ec2_vars["subnet"]
  key_name = var.shared_ec2_vars["keyname"]
  iam_instance_profile = var.shared_ec2_vars["ec2profile"]
  security_groups = [ var.shared_ec2_vars["secgroupid"] ]
  associate_public_ip_address = var.shared_ec2_vars["publicip"]
  tags = merge(
    var.common_app_tags,
    {
      Name = "${vars.solution_details["app_name"]}-${vars.solution_details["env"]}"
    },
  )
}

# Key:
####################################################

# Generates a secure private key and encodes it as PEM
resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
# Create the Key Pair
resource "aws_key_pair" "key_pair" {
  key_name   = "${vars.shared_ec2_vars["keyname"]}"  
  public_key = tls_private_key.key_pair.public_key_openssh
}
# Save file
resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.key_pair.key_name}.pem"
  content  = tls_private_key.key_pair.private_key_pem
}

# EBS Volume:
####################################################

resource "aws_ebs_volume" "data_vol" {
  availability_zone = vars.aws_az
  size = 200
  tags = merge(
    var.common_app_tags,
    {
      Name = "mp-ebs"
    },
  )
}

resource "aws_volume_attachment" "mp_ebs_vol" {
  device_name = "/dev/sdc"
  volume_id = "${aws_ebs_volume.data_vol.id}"
  instance_id = "${aws_instance.media_proxy_ec2.id}"
}

# resource "aws_instance" "ubuntu22" {
#   instance_type = lookup(var.ec2vars, "ec2type")
#   ami = var.amis["ubuntu"]
#   subnet_id = var.ec2vars["subnet"]
#   key_name = var.ec2vars["keyname"]
#   iam_instance_profile = var.ec2vars["ec2profile"]
#   security_groups = [ var.ec2vars["secgroupid"] ]
#   associate_public_ip_address = var.ec2vars["publicip"]
#   tags = merge(
#     var.common_app_tags,
#     {
#       Name = "ssm-poc-${var.env}-ubuntu22"
#       OSFamily = var.ansibletowerosfamily 
#     },
#   )
# }

# resource "aws_instance" "centos7" {
#   instance_type = lookup(var.ec2vars, "ec2type")
#   ami = var.amis["centos7"]
#   subnet_id = var.ec2vars["subnet"]
#   key_name = var.ec2vars["keyname"]
#   iam_instance_profile = var.ec2vars["ec2profile"]
#   security_groups = [ var.ec2vars["secgroupid"] ]
#   associate_public_ip_address = var.ec2vars["publicip"]
#   tags = merge(
#     var.common_app_tags,
#     {
#       Name = "ssm-poc-${var.env}-centos7"
#       OSFamily = var.ansibletowerosfamily 
#     },
#   )
# }

# resource "aws_instance" "rhel7" {
#   instance_type = lookup(var.ec2vars, "ec2type")
#   ami = var.amis["rhel7"]
#   subnet_id = var.ec2vars["subnet"]
#   key_name = var.ec2vars["keyname"]
#   iam_instance_profile = var.ec2vars["ec2profile"]
#   security_groups = [ var.ec2vars["secgroupid"] ]
#   associate_public_ip_address = var.ec2vars["publicip"]
#   tags = merge(
#     var.common_app_tags,
#     {
#       Name = "ssm-poc-${var.env}-rhel7"
#       OSFamily = var.ansibletowerosfamily 
#     },
#   )
# }

# resource "aws_instance" "oracle7" {
#   instance_type = lookup(var.ec2vars, "ec2type")
#   ami = var.amis["oracle7"]
#   subnet_id = var.ec2vars["subnet"]
#   key_name = var.ec2vars["keyname"]
#   iam_instance_profile = var.ec2vars["ec2profile"]
#   security_groups = [ var.ec2vars["secgroupid"] ]
#   associate_public_ip_address = var.ec2vars["publicip"]
#   tags = merge(
#     var.common_app_tags,
#     {
#       Name = "ssm-poc-${var.env}-oracle7"
#       OSFamily = var.ansibletowerosfamily 
#     },
#   )
# }

# resource "aws_instance" "amzn-linux-2-large-ebs" {
#   instance_type = lookup(var.ec2vars, "ec2type")
#   ami = var.amis["amznlinux2"]
#   subnet_id = var.ec2vars["subnet"]
#   key_name = var.ec2vars["keyname"]
#   iam_instance_profile = var.ec2vars["ec2profile"]
#   security_groups = [ var.ec2vars["secgroupid"] ]
#   associate_public_ip_address = var.ec2vars["publicip"]
#   tags = merge(
#     var.common_app_tags,
#     {
#       Name = "ssm-poc-${var.env}-amzn-linux-2-large-ebs"
#       OSFamily = var.ansibletowerosfamily 
#     },
#   )
# }

# # creating and attaching ebs volume

# resource "aws_ebs_volume" "data-vol" {
#   availability_zone = "us-east-1a"
#   size = 200
#   tags = merge(
#     var.common_app_tags,
#     {
#       Name = "SSM-POC-TEST-VOLUME"
#     },
#   )
# }

# resource "aws_volume_attachment" "amzn-linux-2-large-ebs-vol" {
#   device_name = "/dev/sdc"
#   volume_id = "${aws_ebs_volume.data-vol.id}"
#   instance_id = "${aws_instance.amzn-linux-2-large-ebs.id}"
# }

# # Creating VPC S3 endpoint

# resource "aws_vpc_endpoint" "s3" {
#   vpc_id       = var.ec2vars["vpc"]
#   service_name = "com.amazonaws.us-east-1.s3"
#   tags = merge(
#     var.common_app_tags,
#     {
#       Name = "SSM-POC-TEST-S3-VPC-ENDPOINT"
#     },
#   )
#   policy = <<EOF
# {
#   "Statement": [
#     {
#       "Principal": "",
#       "Action": [
#         "s3:GetObject"
#       ],
#       "Effect": "Allow",
#       "Resource": [
#         "arn:aws:s3:::amazonlinux.us-east-1.amazonaws.com/",
#         "arn:aws:s3:::amazonlinux-2-repos-us-east-1/",
#         "arn:aws:s3:::packages.us-east-1.amazonaws.com/",
#         "arn:aws:s3:::repo.us-east-1.amazonaws.com/",
#         "arn:aws:s3:::s3.dualstack.us-east-1.amazonaws.com/*"
#       ]
#     }
#   ]
# }
# EOF
# }

# # associate route table with S3 VPC endpoint

# resource "aws_vpc_endpoint_route_table_association" "route_table_association" {
#   route_table_id  = var.ec2vars["subnetroutingtable"]
#   vpc_endpoint_id = "${aws_vpc_endpoint.s3.id}"
# }

# # Create ssm endpoint:

# resource "aws_vpc_endpoint" "ssm" {
#   subnet_ids         = [ var.ec2vars["subnet"] ]
#   vpc_id            = var.ec2vars["vpc"]
#   service_name      = "com.amazonaws.us-east-1.ssm"
#   vpc_endpoint_type = "Interface"
#   security_group_ids = [ var.ec2vars["secgroupid"] ]
#   private_dns_enabled = true
#   tags = merge(
#     var.common_app_tags,
#     {
#       Name = "SSM-POC-TEST-SSM-ENDPOINT"
#     },
#   )
#   policy = <<EOF
# {
# 	"Version": "2008-10-17",
# 	"Statement": [
# 		{
# 			"Effect": "Allow",
# 			"Principal": "*",
# 			"Action": "*",
# 			"Resource": "*"
# 		}
# 	]
# }
# EOF
# }

# # Create ec2 messages endpoint (required by SSM):

# resource "aws_vpc_endpoint" "ec2messages" {
#   subnet_ids         = [ var.ec2vars["subnet"] ]
#   vpc_id            = var.ec2vars["vpc"]
#   service_name      = "com.amazonaws.us-east-1.ec2messages"
#   vpc_endpoint_type = "Interface"
#   security_group_ids = [ var.ec2vars["secgroupid"] ]
#   private_dns_enabled = true
#   tags = merge(
#     var.common_app_tags,
#     {
#       Name = "SSM-POC-TEST-SSM-EC2-MESSAGES-ENDPOINT"
#     },
#   )
#   policy = <<EOF
# {
# 	"Version": "2008-10-17",
# 	"Statement": [
# 		{
# 			"Effect": "Allow",
# 			"Principal": "*",
# 			"Action": "*",
# 			"Resource": "*"
# 		}
# 	]
# }
# EOF
# }

# # Create ssm messages endpoint (required by SSM):

# resource "aws_vpc_endpoint" "ssmmessages" {
#   subnet_ids         = [ var.ec2vars["subnet"] ]
#   vpc_id            = var.ec2vars["vpc"]
#   service_name      = "com.amazonaws.us-east-1.ssmmessages"
#   vpc_endpoint_type = "Interface"
#   security_group_ids = [ var.ec2vars["secgroupid"] ]
#   private_dns_enabled = true
#   tags = merge(
#     var.common_app_tags,
#     {
#       Name = "SSM-POC-TEST-SSM-MESSAGES-ENDPOINT"
#     },
#   )
#   policy = <<EOF
# {
# 	"Version": "2008-10-17",
# 	"Statement": [
# 		{
# 			"Effect": "Allow",
# 			"Principal": "*",
# 			"Action": "*",
# 			"Resource": "*"
# 		}
# 	]
# }
# EOF
# }
