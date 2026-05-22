<<<<<<< HEAD
# Secure VPC Architecture — AWS Network Security Lab

## Overview
Production-grade three tier VPC architecture implementing defense in depth network security across public, private, and isolated subnets.

## Security Controls Implemented
- Defense in depth — three separate security boundaries
- Least privilege Security Groups — traffic flows one direction only
- Zero internet access for private and isolated subnets
- VPC Flow Logs capturing all network traffic to encrypted S3 bucket
- IAM least privilege — flow logs role can only write to S3

## Architecture
Public Subnet (10.0.1.0/24) — Load balancer, ports 80 and 443 only
Private Subnet (10.0.2.0/24) — App servers, port 8080 from load balancer only
Isolated Subnet (10.0.3.0/24) — Database, port 5432 from app servers only
=======
# Cloud Security Lab — Terraform IaC Portfolio

## Overview
Production-grade AWS security infrastructure built with Terraform, implementing CIS AWS Foundations Benchmark controls across scalable, reusable modules.

## What This Demonstrates
- Infrastructure as Code (IaC) using Terraform
- CIS AWS Benchmark compliance automation (Controls 2.1.1 and 2.1.2)
- Reusable security modules deployable across multiple environments
- Remote state management with encrypted S3 backend
- GitOps workflow with automated security validation

## Security Controls Implemented
CIS 2.1.1 — S3 encryption at rest enforced via AES-256 server side encryption
CIS 2.1.2 — S3 public access blocked with all four settings enforced

## Project Structure
tf-security-lab/
├── main.tf                    # Root configuration and remote state
├── modules/
│   └── secure-bucket/
│       ├── main.tf            # Security rules and resources
│       ├── variables.tf       # Input variables for reusability
│       └── outputs.tf         # Exposed values for reference
>>>>>>> 103ced2701a9e0befbc3ec6acb4bdcfb6a69d52b

## How to Use
terraform init
terraform plan
terraform apply
<<<<<<< HEAD
=======

## Author
Minhazul Abedin | Senior Security Engineer | TS/SCI CI Poly
>>>>>>> 103ced2701a9e0befbc3ec6acb4bdcfb6a69d52b
