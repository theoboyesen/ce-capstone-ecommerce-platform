# Decision: Use Private Subnets for EC2 Instances

## Context

The application instances should not be directly accessible from the public internet for security reasons.

## Decision

Deploy EC2 instances in private subnets and expose them only through the load balancer.

## Consequences

* Improves security by reducing attack surface
* Requires NAT Gateway for outbound internet access
* Adds additional networking complexity and cost
