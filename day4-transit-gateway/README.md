# Transit Gateway — Hub and Spoke Network Architecture

## What I Built

A hub and spoke Transit Gateway connecting three VPCs with explicit
security boundaries enforced at the routing level. Production,
development, and shared services environments all connect through
a central hub but with strict controls on who can talk to who.

## The Design Problem I Was Solving

In any enterprise environment you need multiple isolated networks
that can selectively communicate. The naive solution is direct VPC
peering but that becomes unmanageable fast. Three VPCs means three
peering connections. Ten VPCs means 45. A hundred means nearly 5000.
Transit Gateway solves this with a central hub everything connects to.

## Security Guardrails I Implemented

The most important decision was disabling default route table
association and propagation on the Transit Gateway. By default AWS
lets every VPC reach every other VPC automatically. That is a
security disaster in any environment with different trust levels.

Instead I built explicit route tables for each environment.
Development can reach shared services only and has a blackhole
route to production. Production can reach shared services only
and has a blackhole route to development. Shared services can
reach both because it serves both environments.

## What I Learned

The blackhole route concept was new to me. My instinct was to just
not create a route to production from dev. But the architect
thinking is different — never rely on the absence of a configuration
as a security control. Always rely on an explicit block. Gaps can
be exploited through default routes and misconfigs. Walls cannot.

## Architecture

Development VPC (10.1.0.0/16) → blackhole blocks prod
Production VPC (10.0.0.0/16) → blackhole blocks dev
Both connect through Transit Gateway Hub
Shared Services VPC (10.2.0.0/16) → serves both environments

## How to Use

terraform init
terraform plan
terraform apply
