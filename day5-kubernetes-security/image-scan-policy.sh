#!/bin/bash
# Image Security Scan Policy
# Blocks deployment if CRITICAL or HIGH vulnerabilities found
# Warns on MEDIUM
# Usage: ./image-scan-policy.sh <image-name>

IMAGE=$1

if [ -z "$IMAGE" ]; then
  echo "Usage: $0 <image-name>"
  exit 1
fi

echo "============================================"
echo "  Scanning image: $IMAGE"
echo "  Policy: Block on CRITICAL/HIGH"
echo "============================================"

# Scan for CRITICAL and HIGH — these block deployment
trivy image "$IMAGE" \
  --format table \
  --severity CRITICAL,HIGH \
  --exit-code 1 \
  --quiet 2>/dev/null

EXIT_CODE=$?

if [ $EXIT_CODE -eq 1 ]; then
  echo ""
  echo "DEPLOYMENT BLOCKED — CRITICAL or HIGH vulnerabilities found"
  echo "Remediation required before deployment"
  exit 1
else
  echo "CRITICAL/HIGH scan: PASSED"
fi

echo ""
echo "--------------------------------------------"
echo "  Checking MEDIUM vulnerabilities (warning only)"
echo "--------------------------------------------"

# Scan for MEDIUM — these warn but do not block
trivy image "$IMAGE" \
  --format table \
  --severity MEDIUM \
  --quiet 2>/dev/null

echo ""
echo "MEDIUM scan complete — review findings above"
echo "Deployment APPROVED with risk acceptance if required"
exit 0
