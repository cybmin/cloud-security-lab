terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket       = "minhazul-terraform-state-98472"
    key          = "global/s3/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }
}

provider "aws" {
  region = "us-east-1"
}

# ── STATE INFRASTRUCTURE ──
resource "aws_s3_bucket" "terraform_state" {
  bucket = "minhazul-terraform-state-98472"

  tags = {
    Name        = "Terraform State Bucket"
    Environment = "mgmt"
    Owner       = "Minhazul"
  }
}

resource "aws_s3_bucket_versioning" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

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
}