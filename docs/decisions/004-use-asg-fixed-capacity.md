# Decision: Use Fixed Capacity Auto Scaling Group

## Context

The application requires high availability but does not need dynamic scaling for this use case.

## Decision

Configure the Auto Scaling Group with a fixed capacity of three instances.

## Consequences

* Ensures high availability across availability zones
* Simplifies configuration
* Less flexible than dynamic scaling policies
