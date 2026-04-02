# Incident: Unhealthy Targets in Load Balancer

## Summary

All EC2 instances were marked as unhealthy by the Application Load Balancer.

## Impact

* Application unavailable via ALB
* Requests resulted in 502 errors

## Root Cause

The application was not responding correctly to the health check endpoint.

## Resolution

* Verified `/health` endpoint returned HTTP 200
* Ensured application was listening on port 3000

## Lessons Learned

* Health check endpoints must be simple and reliable
* ALB errors often indicate application-level issues
