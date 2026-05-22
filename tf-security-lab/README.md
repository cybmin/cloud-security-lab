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

## How to Use
terraform init
terraform plan
terraform apply

## Author
Minhazul Abedin | Senior Security Engineer | TS/SCI CI Poly
