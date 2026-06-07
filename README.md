# Cloud Security Engineering Portfolio

**Minhazul Abedin** | github.com/cybmin

---

## The Problem This Portfolio Solves

In an unprotected cloud environment a single misconfigured container gives an attacker a JWT token to authenticate to the Kubernetes API server, unrestricted network access to reach every pod in the cluster, and root privileges to do anything they want. From there they can move laterally to other namespaces, steal sensitive data, and take down the entire system. I built this portfolio to make that attack path structurally impossible at every layer from the moment code is written to the moment a container runs in production.

---

## The Most Important Thing I Learned

A security control that breaks functionality gets disabled. A disabled control is worse than no control because you think you are protected when you are not. The best security is strict enough to stop the attack and functional enough that engineers never feel the need to turn it off. I learned this the hard way when my Kubernetes network policies were so strict they broke DNS resolution across the entire cluster. The fix was surgical. That experience changed how I think about every control I build.

---

## What I Built

### Day 1 and 2 — Terraform Security and CI/CD
Built reusable Terraform modules enforcing CIS AWS Benchmark controls 2.1.1 and 2.1.2 automatically on every S3 deployment. Configured encrypted remote state backend with state locking. Built a GitHub Actions CI/CD pipeline that validates security configurations on every code push.

The key insight: security as code means security that enforces itself. A checklist depends on humans remembering. A Terraform module enforces the control whether anyone remembers or not.

### Day 3 — Secure VPC Architecture
Architected a three-tier VPC with defense-in-depth security group chaining across public, private, and isolated subnets. Enforced least-privilege traffic rules using security group ID references rather than IP ranges. Implemented VPC Flow Logs to an encrypted CIS-hardened S3 bucket.

### Day 4 — Transit Gateway Hub and Spoke
Designed hub-and-spoke network architecture connecting production, development, and shared-services VPCs. Disabled default route propagation. Implemented blackhole routes that actively drop dev-to-prod traffic at the routing layer.

The principle: gaps can be exploited. Walls cannot. Never rely on the absence of a configuration as a security control.

### Day 5 — Kubernetes Security
Deployed an insecure pod running as root and proved the attack path hands on — found a real JWT service account token inside the container in under five minutes. Then deployed a hardened pod and proved each control works by trying to bypass it. Built three-tier network policies with Calico CNI enforcing deny-by-default segmentation.

### Day 6 — Image Scanning and Admission Control
Scanned real production images with Trivy. Ubuntu returned 72 vulnerabilities including 9 HIGH. Alpine returned zero. Built an automated scan policy script with exit-code enforcement. Deployed OPA/Gatekeeper with a ConstraintTemplate in Rego blocking any pod with runAsUser 0. Tried to deploy the insecure pod — Kubernetes itself rejected it.

---

## The Full Defense in Depth Stack
---

## What I Would Build Next

EKS lab covering IRSA, EKS Pod Identity, and GuardDuty for runtime threat detection. Then AI security week covering prompt injection defenses, agentic AI security controls, LLM governance frameworks, and shadow AI discovery.

---

## Repository Structure
---

## Technical Stack

**IaC and CI/CD:** Terraform, GitHub Actions, CIS Benchmarks

**Cloud:** AWS VPC, Transit Gateway, S3, IAM

**Kubernetes:** minikube, Calico CNI, OPA/Gatekeeper, Trivy, Network Policies

**Security concepts:** Defense in depth, least privilege networking, admission control, image scanning, zero-trust architecture, shift-left security

---

*Built to demonstrate the thinking behind the controls — not just the tools.*
