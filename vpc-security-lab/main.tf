terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
<<<<<<< HEAD
=======

  backend "s3" {
    bucket       = "minhazul-terraform-state-98472"
    key          = "global/s3/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
>>>>>>> 103ced2701a9e0befbc3ec6acb4bdcfb6a69d52b
}

provider "aws" {
  region = "us-east-1"
}

<<<<<<< HEAD
# ── VPC ──
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "secure-vpc"
    Environment = "dev"
    Owner       = "Minhazul"
  }
}
# ── SUBNETS ──

# Public subnet — load balancer lives here
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
    Tier = "public"
  }
}

# Private subnet — application servers live here
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-subnet"
    Tier = "private"
  }
}

# Isolated subnet — database lives here
resource "aws_subnet" "isolated" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "isolated-subnet"
    Tier = "isolated"
  }
}
# ── INTERNET GATEWAY ──
# This is the door between your VPC and the public internet
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "secure-vpc-igw"
  }
}

# ── ROUTE TABLES ──
# Public route table — sends internet traffic through the gateway
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "public-rt"
  }
}

# Associate public route table with public subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Private route table — no internet access
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-rt"
  }
}

# Associate private route table with private subnet
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# Isolated route table — completely locked down
resource "aws_route_table" "isolated" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "isolated-rt"
  }
}

# Associate isolated route table with isolated subnet
resource "aws_route_table_association" "isolated" {
  subnet_id      = aws_subnet.isolated.id
  route_table_id = aws_route_table.isolated.id
}
# ── SECURITY GROUPS ──

# Public security group — load balancer only
# Only allows HTTPS inbound from anywhere
resource "aws_security_group" "public" {
  name        = "public-sg"
  description = "Security group for public subnet - load balancer only"
  vpc_id      = aws_vpc.main.id

  # Allow HTTPS from anywhere
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTPS from internet"
  }

  # Allow HTTP from anywhere — redirects to HTTPS
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow HTTP from internet"
  }

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = {
    Name = "public-sg"
  }
}

# Private security group — app servers
# Only accepts traffic from public subnet
resource "aws_security_group" "private" {
  name        = "private-sg"
  description = "Security group for private subnet - app servers"
  vpc_id      = aws_vpc.main.id

  # Only allow traffic from public security group
  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.public.id]
    description     = "Allow traffic from load balancer only"
  }

  # Allow all outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound"
  }

  tags = {
    Name = "private-sg"
  }
}

# Isolated security group — database
# Only accepts traffic from private subnet
resource "aws_security_group" "isolated" {
  name        = "isolated-sg"
  description = "Security group for isolated subnet - database only"
  vpc_id      = aws_vpc.main.id

  # Only allow database traffic from private security group
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.private.id]
    description     = "Allow PostgreSQL from app servers only"
  }

  # No outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
    description = "Allow outbound within VPC only"
  }

  tags = {
    Name = "isolated-sg"
  }
}
# ── VPC FLOW LOGS ──

# S3 bucket to store flow logs
resource "aws_s3_bucket" "flow_logs" {
  bucket = "minhazul-vpc-flow-logs-98472"

  tags = {
    Name        = "VPC Flow Logs"
    Environment = "dev"
=======
# ── STATE INFRASTRUCTURE ──
resource "aws_s3_bucket" "terraform_state" {
  bucket = "minhazul-terraform-state-98472"

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "mgmt"
>>>>>>> 103ced2701a9e0befbc3ec6acb4bdcfb6a69d52b
    Owner       = "Minhazul"
  }
}

<<<<<<< HEAD
# Encrypt the flow logs bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "flow_logs" {
  bucket = aws_s3_bucket.flow_logs.id

=======
resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
>>>>>>> 103ced2701a9e0befbc3ec6acb4bdcfb6a69d52b
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

<<<<<<< HEAD
# Block public access to flow logs
resource "aws_s3_bucket_public_access_block" "flow_logs" {
  bucket                  = aws_s3_bucket.flow_logs.id
=======
resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket                  = aws_s3_bucket.terraform_state.id
>>>>>>> 103ced2701a9e0befbc3ec6acb4bdcfb6a69d52b
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

<<<<<<< HEAD
# Enable VPC Flow Logs
resource "aws_flow_log" "main" {
  vpc_id               = aws_vpc.main.id
  traffic_type         = "ALL"
  log_destination_type = "s3"
  log_destination      = aws_s3_bucket.flow_logs.arn
  }


# IAM role for flow logs
resource "aws_iam_role" "flow_logs" {
  name = "vpc-flow-logs-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })
}

# IAM policy for flow logs role
resource "aws_iam_role_policy" "flow_logs" {
  name = "vpc-flow-logs-policy"
  role = aws_iam_role.flow_logs.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject"
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.flow_logs.arn}/*"
      }
    ]
  })
=======
# ── SECURITY BUCKETS ──
module "security_bucket_1" {
  source      = "./modules/secure-bucket"
  bucket_name = "minhazul-prod-bucket-98472"
  environment = "prod"
  owner       = "Minhazul"
}

module "security_bucket_2" {
  source      = "./modules/secure-bucket"
  bucket_name = "minhazul-dev-bucket-98472"
  environment = "dev"
  owner       = "Minhazul"
>>>>>>> 103ced2701a9e0befbc3ec6acb4bdcfb6a69d52b
}