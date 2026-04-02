# Decision: Implement Dedicated Health Check Endpoint

## Context

The load balancer requires a reliable way to determine instance health.

## Decision

Implement a `/health` endpoint returning HTTP 200.

## Consequences

* Enables accurate health monitoring
* Separates health checks from application logic
* Requires maintaining endpoint availability

