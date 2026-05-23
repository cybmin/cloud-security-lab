terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# ── VPC 1 — PRODUCTION ──
# Highest trust environment — no direct access from dev
resource "aws_vpc" "production" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "production-vpc"
    Environment = "production"
    Trust       = "high"
    Owner       = "Minhazul"
  }
}

# ── VPC 2 — DEVELOPMENT ──
# Lower trust environment — can never reach production directly
resource "aws_vpc" "development" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "development-vpc"
    Environment = "development"
    Trust       = "low"
    Owner       = "Minhazul"
  }
}

# ── VPC 3 — SHARED SERVICES ──
# Central services both prod and dev need — DNS, monitoring, logging
resource "aws_vpc" "shared_services" {
  cidr_block           = "10.2.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "shared-services-vpc"
    Environment = "shared"
    Trust       = "medium"
    Owner       = "Minhazul"
  }
}
# ── TRANSIT GATEWAY ──
# The central hub connecting all VPCs and on-premises
# Think of this as your core router from your Cisco days
# but managed by AWS and infinitely scalable
resource "aws_ec2_transit_gateway" "main" {
  description                     = "Central hub connecting prod, dev, and shared services"
  default_route_table_association = "disable"
  default_route_table_propagation = "disable"

  tags = {
    Name  = "main-tgw"
    Owner = "Minhazul"
  }
}

# ── TRANSIT GATEWAY ATTACHMENTS ──
# These connect each VPC to the Transit Gateway hub
# Like plugging cables into your core switch

# Production VPC attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "production" {
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = aws_vpc.production.id
  subnet_ids         = [aws_subnet.production.id]

  tags = {
    Name = "production-tgw-attachment"
  }
}

# Development VPC attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "development" {
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = aws_vpc.development.id
  subnet_ids         = [aws_subnet.development.id]

  tags = {
    Name = "development-tgw-attachment"
  }
}

# Shared Services VPC attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "shared_services" {
  transit_gateway_id = aws_ec2_transit_gateway.main.id
  vpc_id             = aws_vpc.shared_services.id
  subnet_ids         = [aws_subnet.shared_services.id]

  tags = {
    Name = "shared-services-tgw-attachment"
  }
}
# ── SUBNETS FOR TRANSIT GATEWAY ATTACHMENTS ──
# Each VPC needs at least one subnet for the TGW to attach to

resource "aws_subnet" "production" {
  vpc_id            = aws_vpc.production.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "production-tgw-subnet"
  }
}

resource "aws_subnet" "development" {
  vpc_id            = aws_vpc.development.id
  cidr_block        = "10.1.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "development-tgw-subnet"
  }
}

resource "aws_subnet" "shared_services" {
  vpc_id            = aws_vpc.shared_services.id
  cidr_block        = "10.2.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "shared-services-tgw-subnet"
  }
}
# ── TRANSIT GATEWAY ROUTE TABLES ──
# Explicit routing policy — deny by default, permit by exception

# Production route table
# Production can reach shared services only
# Production cannot reach development
resource "aws_ec2_transit_gateway_route_table" "production" {
  transit_gateway_id = aws_ec2_transit_gateway.main.id

  tags = {
    Name = "production-tgw-rt"
  }
}

# Development route table  
# Development can reach shared services only
# Development CANNOT reach production — blackhole enforces this
resource "aws_ec2_transit_gateway_route_table" "development" {
  transit_gateway_id = aws_ec2_transit_gateway.main.id

  tags = {
    Name = "development-tgw-rt"
  }
}

# Shared services route table
# Shared services can reach both prod and dev
# It needs to serve both environments
resource "aws_ec2_transit_gateway_route_table" "shared_services" {
  transit_gateway_id = aws_ec2_transit_gateway.main.id

  tags = {
    Name = "shared-services-tgw-rt"
  }
}

# ── ROUTE TABLE ASSOCIATIONS ──
# Connect each VPC attachment to its route table
# Like assigning a VLAN to a switchport in Cisco

resource "aws_ec2_transit_gateway_route_table_association" "production" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.production.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.production.id
}

resource "aws_ec2_transit_gateway_route_table_association" "development" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.development.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.development.id
}

resource "aws_ec2_transit_gateway_route_table_association" "shared_services" {
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.shared_services.id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.shared_services.id
}

# ── ROUTES — THE ACTUAL GUARDRAILS ──

# Production routes — can reach shared services only
resource "aws_ec2_transit_gateway_route" "prod_to_shared" {
  destination_cidr_block         = "10.2.0.0/16"
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.production.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.shared_services.id
}

# Production blackhole — explicitly drop any traffic toward dev
resource "aws_ec2_transit_gateway_route" "prod_to_dev_blackhole" {
  destination_cidr_block         = "10.1.0.0/16"
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.production.id
  blackhole                      = true
}

# Development routes — can reach shared services only
resource "aws_ec2_transit_gateway_route" "dev_to_shared" {
  destination_cidr_block         = "10.2.0.0/16"
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.development.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.shared_services.id
}

# Development blackhole — explicitly drop any traffic toward production
# This is the critical guardrail — dev CANNOT reach prod ever
resource "aws_ec2_transit_gateway_route" "dev_to_prod_blackhole" {
  destination_cidr_block         = "10.0.0.0/16"
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.development.id
  blackhole                      = true
}

# Shared services routes — can reach both prod and dev
resource "aws_ec2_transit_gateway_route" "shared_to_prod" {
  destination_cidr_block         = "10.0.0.0/16"
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.shared_services.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.production.id
}

resource "aws_ec2_transit_gateway_route" "shared_to_dev" {
  destination_cidr_block         = "10.1.0.0/16"
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.shared_services.id
  transit_gateway_attachment_id  = aws_ec2_transit_gateway_vpc_attachment.development.id
}