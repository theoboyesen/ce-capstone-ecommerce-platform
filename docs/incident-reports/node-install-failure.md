# Incident: Node.js Installation Failure

## Summary

EC2 instances failed to start the application due to Node.js installation errors.

## Impact

* Application did not start
* Targets marked as unhealthy in the load balancer

## Root Cause

Node.js 18 required a newer glibc version than available on Amazon Linux 2.

## Resolution

Switched to Node.js 16, which is compatible with the system libraries.

## Lessons Learned

* Always verify runtime compatibility with base OS
* Review system logs when installation fails
