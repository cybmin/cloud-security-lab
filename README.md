# Cloud Security Engineering Portfolio
Minhazul Abedin | Security Engineer | TS/SCI CI Poly

## Why I Built This

Honestly I wanted to level up my career and stay competitive in 
a field that moves fast. After 8 years in cybersecurity across 
the military, government, and commercial environments I realized 
I had solid security fundamentals but needed to modernize my 
cloud and automation knowledge to match where the industry is going.

So instead of just reading about Terraform and Kubernetes I decided 
to actually build things. Real infrastructure. Real security 
controls. Deployed to a real AWS account. This portfolio is that 
journey documented as I go.

## What I've Learned So Far

Terraform was way easier than I expected once I stopped reading 
about it and started building. The hands on approach clicked fast 
especially coming from a networking background where I already 
think in terms of traffic flow, segmentation, and security 
boundaries.

CI/CD pipelines were new territory for me. Getting GitHub Actions 
to automatically validate my security configs on every push was 
genuinely satisfying. Watching the green checkmark appear after 
debugging a pipeline error felt more rewarding than any 
multiple choice exam ever did.

The biggest mindset shift has been thinking about security as code 
rather than a checklist. When your encryption policy lives in a 
Terraform file that is versioned, peer reviewed, and automatically 
tested on every change that is a completely different level of 
confidence than hoping someone remembered to tick a box.

## Labs

### Lab 1 — S3 Security and IaC Foundation
Location: tf-security-lab/

Built a reusable Terraform module that enforces CIS AWS Benchmark 
controls on S3 buckets automatically. Set up remote state in an 
encrypted S3 backend with state locking. Built a GitHub Actions 
CI/CD pipeline that validates security configs on every code push.

Biggest lesson from this one: I accidentally staged my AWS 
credentials file and tried to push it to GitHub mid lab. GitHub 
secret scanning caught it instantly and blocked the push. I rotated 
the keys immediately, fixed the gitignore, and kept moving. Better 
to learn that lesson in a personal lab than in a production 
environment protecting real assets.

### Lab 2 — Secure VPC Network Architecture
Location: vpc-security-lab/

Built a three tier VPC from scratch with public, private, and 
isolated subnets. I designed the architecture thinking about 
both the defensive and offensive angles which is what Purple 
Team work trains you to do. If I compromised the load balancer 
what is my blast radius? If I got a foothold on an app server 
how do I reach the database?

The answer with this architecture is that I cannot easily. Three 
separate security boundaries with least privilege rules and no 
internet routes on the sensitive tiers. VPC Flow Logs capture 
everything to an encrypted bucket so there is always a full audit 
trail. I also hit a real bug where Terraform defaulted to 
CloudWatch instead of S3 for flow log delivery and had to debug 
it live which was a useful learning moment.

### Lab 3 — Transit Gateway Hub and Spoke Architecture
Location: day4-transit-gateway/

Built a Transit Gateway connecting three VPCs with explicit 
security boundaries enforced at the routing level. The key 
insight here was disabling default route propagation so nothing 
connects automatically. Every permitted path is explicitly defined 
and every blocked path has a blackhole route actively dropping 
the traffic.

The architect lesson that stuck with me: never rely on the absence 
of a configuration as a security control. A missing route leaves 
ambiguity. A blackhole route is an explicit wall. Gaps can be 
exploited. Walls cannot.

## Coming Soon

Kubernetes security and EKS hardening, AI security and LLM threat 
mitigation, and a combined cloud and AI security reference 
architecture that ties everything together into one cohesive 
portfolio project.

## Background

8 years in cybersecurity spanning military service, government 
programs, and commercial industry. I started in IT help desk and 
network administration which gave me a strong technical foundation 
before moving into security. My experience since then has been a 
mix of SOC operations, Purple Team consulting, penetration testing, 
and vulnerability management across federal and private sector 
environments. Currently a Security Engineer and Purple Team 
Consultant holding an active TS/SCI CI Poly clearance.

This portfolio represents my intentional push into cloud security 
engineering and AI security — taking the broad security foundation 
I have built over 8 years and adding modern infrastructure 
automation and cloud native security skills on top of it.
