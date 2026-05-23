# S3 Security and IaC Foundation

## What I Built

A reusable Terraform module that automatically enforces CIS AWS 
Benchmark controls on S3 buckets. Remote state stored in an 
encrypted S3 backend with state locking so multiple engineers 
can work safely without stepping on each other. A GitHub Actions 
CI/CD pipeline that validates security configs on every single 
code push without anyone having to remember to check manually.

## Honest First Impressions of Terraform

I expected this to be harder than it was. Coming from a security 
background where I spent years clicking through consoles and 
running manual assessments I assumed Infrastructure as Code would 
feel like learning a completely foreign language.

It did not. The syntax gets annoying until it clicks and then it 
just clicks. My definition of infrastructure as code after actually 
doing it is simpler than any textbook version — you write down what 
you want to exist and Terraform makes it exist. Every time. 
Identically. Without you having to remember every step.

That consistency is what makes it a security tool not just a 
convenience tool. Human memory is unreliable. Terraform is not.

## Security Controls Implemented

CIS AWS Benchmark Control 2.1.1 — every S3 bucket enforces 
AES-256 encryption at rest automatically. No engineer has to 
remember to enable it. The module makes it impossible to forget.

CIS AWS Benchmark Control 2.1.2 — all four public access block 
settings enforced on every bucket. A misconfigured public S3 
bucket is one of the most common causes of cloud data breaches. 
This makes that misconfiguration impossible.

## The Credential Incident

Mid lab I accidentally staged my AWS credentials CSV file and 
tried to push it to GitHub. GitHub secret scanning caught it 
instantly and blocked the push before anything was exposed. 
I rotated the keys immediately, removed the file from Git 
history, added CSV files to gitignore, and kept going.

That whole incident took about five minutes to remediate. 
The lesson was not that I made a mistake — everyone makes that 
mistake once. The lesson was that the response matters more than 
the mistake. Identify, contain, rotate, prevent recurrence. 
Same incident response process I have applied in real environments 
just in a personal lab this time.

## What the CI/CD Pipeline Actually Does

Every time I push code to GitHub a fresh Linux machine spins up 
in the cloud, installs Terraform, initializes the project, and 
validates every security configuration automatically. If something 
is broken it fails before it ever reaches AWS. If everything looks 
good it passes with a green checkmark.

The first time I saw that green checkmark after debugging a 
pipeline error it felt more satisfying than passing any 
certification exam. Because it was real infrastructure doing 
real validation not a multiple choice question.

## Project Structure

tf-security-lab/
├── main.tf — root config and remote state backend
├── modules/
│   └── secure-bucket/
│       ├── main.tf — CIS security rules
│       ├── variables.tf — inputs for reusability
│       └── outputs.tf — exposed values for reference
└── .github/
    └── workflows/
        └── terraform-security-check.yml — CI/CD pipeline

## How to Use

terraform init
terraform plan
terraform apply
