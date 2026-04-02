# Incident: Difficulty Isolating Root Cause

## Summary

It was initially unclear whether failures were caused by infrastructure or application issues.

## Impact

* Slower debugging process
* Multiple unnecessary changes

## Root Cause

Lack of visibility into EC2 instance behaviour and logs.

## Resolution

Used EC2 system logs and ALB health checks to identify the issue at the application layer.

## Lessons Learned

* Always check logs before making changes
* Separate infrastructure and application debugging
