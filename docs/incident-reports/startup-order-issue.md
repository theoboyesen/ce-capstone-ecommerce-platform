# Incident: Application Startup Failure Due to Script Order

## Summary

Instances launched successfully but the application did not start consistently.

## Impact

* Intermittent unhealthy instances
* Delayed availability

## Root Cause

CloudWatch agent installation was executed before the application started, causing delays or script failures.

## Resolution

Reordered the user_data script to start the application before installing additional services.

## Lessons Learned

* Order of operations in bootstrap scripts is critical
* Keep application startup independent of optional services
