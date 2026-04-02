# Decision: Use Node.js 16 Instead of Node.js 18

## Context

Node.js 18 failed to install on Amazon Linux 2 due to system library (glibc) incompatibility.

## Decision

Use Node.js 16, which is compatible with the base AMI.

## Consequences

* Ensures successful installation and application startup
* Slightly older runtime version
* Avoids dependency conflicts

