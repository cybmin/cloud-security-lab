# Secure VPC Network Architecture

## What I Built

A three tier VPC from scratch with public, private, and isolated 
subnets. Security groups enforcing least privilege traffic rules 
at every tier. VPC Flow Logs capturing all network traffic to an 
encrypted S3 bucket. Everything deployed as Terraform so it is 
reproducible anywhere in minutes.

## How My Network Background Helped and Where It Did Not

Coming from network administration and Cisco infrastructure work 
in the military this lab felt familiar in the right ways. Subnets, 
routing tables, traffic flow, segmentation — these are concepts 
I have worked with for years. Translating them to AWS just required 
learning the cloud specific terminology.

The part that required new thinking was defense in depth applied 
to cloud tiers specifically. In physical networking you think about 
segments. In cloud security you think about what lives where and 
why — the load balancer belongs in the public subnet, the 
application servers belong in the private subnet, the database 
belongs in the isolated subnet, and each tier only communicates 
on the specific ports it actually needs. Nothing more.

That precision matters. Every open port is an attack surface. 
Every unnecessary route is a potential pivot point for an attacker.

## The Security Concept That Actually Made Me Think

Security group chaining. Instead of allowing traffic from an IP 
address range I reference the security group ID of the upstream 
resource directly.

The difference matters more than it seems. If a rule says allow 
traffic from 10.0.2.0/24 an attacker who compromises any machine 
can spoof an IP in that range and potentially bypass the rule. 
When you reference a security group ID AWS enforces that only 
resources actually attached to that group can communicate — 
regardless of what IP address they have. You cannot spoof 
security group membership. Only AWS controls that.

That one concept changed how I think about cloud firewall rules. 
IP based rules are weak. Security group chaining is a real control.

## The Defense in Depth Architecture

Public subnet hosts the load balancer and accepts HTTPS on port 
443 from the internet. Private subnet hosts application servers 
and only accepts traffic from the load balancer security group 
on port 8080 — not from any IP range, from the security group ID 
specifically. Isolated subnet hosts the database and only accepts 
PostgreSQL on port 5432 from the application server security group.

The isolated subnet egress is locked to the VPC CIDR only. Even 
if an attacker compromises the database they cannot call back to 
a C2 server over the internet. The routing physically prevents it.

An attacker trying to reach the database has to breach three 
separate security boundaries instead of one. That is defense 
in depth in practice not just in theory.

## VPC Flow Logs

Every network connection in this VPC is logged — source and 
destination IPs, ports, protocols, bytes transferred, and whether 
traffic was accepted or rejected. Coming from a background of 
analyzing PCAPs and network traffic this felt natural. Flow logs 
are just cloud native netflow.

The logs go to an encrypted S3 bucket with CIS hardening applied. 
Logs are a target too. An attacker who compromises your environment 
wants to delete the evidence. Locking down the log storage is not 
optional.

## What I Would Harden Further

Port 80 is open on the public subnet even though it redirects to 
HTTPS. That is still an attack surface worth closing in a 
production environment. The private subnet egress allows all 
outbound internet traffic which means a compromised app server 
could call back to a C2 server. In a real deployment I would 
restrict that to specific destinations only.

Thinking about your own architecture from an attacker perspective 
is something Purple Team work builds naturally. Build it, then 
immediately ask yourself how you would break it.

## How to Use

terraform init
terraform plan
terraform apply
