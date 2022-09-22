# Create the VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = merge(
    var.common_app_tags,
    {
      Name = "${vars.solution_details["app_name"]}-${vars.solution_details["env"]}-vpc"
    },
  )
}

# Define the private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.aws_az
  tags = merge(
    var.common_app_tags,
    {
      Name = "${vars.solution_details["app_name"]}-${vars.solution_details["env"]}-private-subnet"
    },
  )
}

# Define the private route table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    var.common_app_tags,
    {
      Name = "${vars.solution_details["app_name"]}-${vars.solution_details["env"]}-private-rt"
    },
  )
}

# Assign the private route table to the private subnet
resource "aws_route_table_association" "private_rt_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Define the public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.public_subnet_cidr
  availability_zone = var.aws_az
  tags = merge(
    var.common_app_tags,
    {
      Name = "${vars.solution_details["app_name"]}-${vars.solution_details["env"]}-public-subnet"
    },
  )
}

# Define the internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = merge(
    var.common_app_tags,
    {
      Name = "${vars.solution_details["app_name"]}-${vars.solution_details["env"]}-igw"
    },
  )
}

# Define the public route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(
    var.common_app_tags,
    {
      Name = "${vars.solution_details["app_name"]}-${vars.solution_details["env"]}-private-rt"
    },
  )
}

# Assign the public route table to the public subnet
resource "aws_route_table_association" "public_rt_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}