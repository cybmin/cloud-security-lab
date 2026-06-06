# Day 5 — Kubernetes Security Lab

## Why I Built This

Coming from a network security background I kept hearing that
Kubernetes security is complicated. After building this lab I
realized it is not complicated at all once you connect it to
concepts you already know. A Kubernetes cluster is just a VPC
with pods instead of servers. The same layered defense model
applies. The same least privilege principles apply. The tools
have different names but the thinking is identical.

## What I Actually Learned

The biggest thing that clicked for me was how similar Kubernetes
network policies are to AWS VPC security groups and subnets. I
built the same three tier architecture I built in Day 3 — frontend
that accepts outside traffic, backend that only talks to frontend,
database that only talks to backend. In AWS that was security
groups and route tables. In Kubernetes that is network policies
and Calico. Same mental model, different environment.

The second thing that stuck was seeing the attack from the inside
first before building any defenses. When I exec'd into the
insecure pod and found a real JWT token sitting in
/var/run/secrets I understood immediately why automounting
service account tokens is dangerous. Reading about it in
documentation is different from actually finding the token
yourself and understanding what an attacker does with it.

## The Lesson That Actually Matters

I made our network policies too strict at first and broke DNS
resolution. Every pod in the cluster stopped being able to resolve
service names. Nothing worked.

The fix was adding a specific exception for port 53 UDP and TCP
so DNS queries could reach CoreDNS while everything else stayed
locked down. Surgical exception, not a broad loosening.

That frustrating moment taught me something I will not forget:
a security control that breaks functionality gets disabled. A
disabled control is worse than no control because you think you
are protected when you are not. Security has to be strict enough
to prevent the attack and functional enough that engineers do not
fight you. That balance is what matters.

## What I Built

Three layers of Kubernetes security proving defense in depth
across the full container lifecycle.

Layer 1 deployed an insecure pod running as root and showed
the exact attack path — real JWT token exposed, API server
address in environment variables, full filesystem write access.
Then deployed a hardened pod and proved each control works by
trying to bypass it.

Layer 2 built three tier network segmentation with Calico
enforcing deny-by-default policies. Frontend reaching database
directly timed out with no connection. Lateral movement from
the insecure pod was blocked. The permitted paths worked exactly
as designed.

## The Frustrating Part

Getting minikube running with Calico took longer than expected.
The default minikube setup does not enforce network policies so
our policies existed as objects in the cluster but nothing
actually blocked any traffic. Had to delete the cluster entirely
and restart with the Calico CNI flag. Also had to make sure
Docker Desktop was running before starting minikube or the whole
thing fails silently. Those are the kinds of things you only
learn by running into them.

## Files

insecure-pod.yaml — the threat model made visible
secure-pod.yaml — hardened pod with five security controls
network-policy-lab.yaml — three tier pod architecture
services.yaml — Kubernetes services enabling pod communication
network-policies.yaml — deny-by-default network isolation

## How to Run It

minikube start --driver=docker --cni=calico
kubectl create namespace security-lab
kubectl apply -f insecure-pod.yaml
kubectl apply -f secure-pod.yaml
kubectl apply -f network-policy-lab.yaml
kubectl apply -f services.yaml
kubectl apply -f network-policies.yaml
