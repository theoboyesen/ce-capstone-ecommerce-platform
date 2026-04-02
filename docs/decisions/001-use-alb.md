# Decision: Use Application Load Balancer

## Context

The application requires distribution of incoming traffic across multiple EC2 instances and needs built-in health checking.

## Decision

Use an AWS Application Load Balancer (ALB) to route HTTP traffic to EC2 instances.

## Consequences

* Enables load balancing and high availability
* Provides built-in health checks
* Adds additional cost compared to direct instance access
