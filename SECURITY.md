# Security

## Network Security

### Private Subnets

EC2 instances are deployed in private subnets and are not directly accessible from the internet.

### Security Groups

* ALB:

  * Allows inbound HTTP (port 80) from the internet
* EC2:

  * Allows inbound traffic only from ALB on port 3000
  * No public access

## Least Privilege

* Security group rules restrict traffic to only required sources
* EC2 instances do not expose unnecessary ports

## IAM

* EC2 instances use an IAM role for CloudWatch logging
* No hardcoded credentials are used

## Data Protection

* No sensitive data stored in the application
* Metadata access restricted to instance context

## Monitoring

* CloudWatch alarms detect:

  * High CPU usage
  * Unhealthy instances
  * High response times

## Summary

The system follows basic security best practices including network isolation, least privilege access, and monitoring.
