# Cloud Security Engineering Portfolio
### Minhazul Abedin | Senior Security Engineer | TS/SCI CI Poly

## Overview
A collection of production-grade cloud security engineering labs built with Terraform, implementing real enterprise security controls across AWS infrastructure. Each lab demonstrates hands-on expertise in a specific domain of cloud security architecture.

## Labs

### Lab 1 — S3 Security & IaC Foundation
Location: tf-security-lab/
- CIS AWS Benchmark compliance automation (Controls 2.1.1 and 2.1.2)
- Reusable Terraform security modules deployable across multiple environments
- Remote state management with encrypted S3 backend and state locking
- GitHub Actions CI/CD pipeline for automated security validation on every push

### Lab 2 — Secure VPC Network Architecture
Location: vpc-security-lab/
- Three tier defense in depth network segmentation
- Least privilege Security Groups — traffic flows one direction only
- Zero internet access for private and isolated subnets
- VPC Flow Logs capturing all network traffic to encrypted S3 bucket
- IAM least privilege for flow log delivery

## Coming Soon
- Lab 3 — Transit Gateway and hybrid cloud connectivity
- Lab 4 — Kubernetes security and EKS hardening
- Lab 5 — AI security and LLM threat mitigation
- Lab 6 — Combined cloud and AI security reference architecture

## Security Frameworks
- CIS AWS Foundations Benchmark
- NIST Cybersecurity Framework
- OWASP Top 10 for LLMs (coming in Lab 5)

## Author
Minhazul Abedin
Senior Security Engineer
