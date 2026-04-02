# Security

## Overview

The system is designed with basic cloud security best practices, including network isolation, least privilege access, and monitoring.

---

## Network Security

### Private Subnets

EC2 instances are deployed in private subnets and are not directly accessible from the internet.

### Security Groups

* **ALB Security Group**

  * Allows inbound HTTP (port 80) from the internet

* **EC2 Security Group**

  * Allows inbound traffic only from the ALB on port 3000
  * No public access

---

## IAM

* EC2 instances use an IAM role to interact with CloudWatch
* No hardcoded credentials are used

---

## Secrets Management

No sensitive data or credentials are stored in the application. IAM roles are used for secure access to AWS services.

---

## Monitoring

CloudWatch is used to monitor:

* CPU utilisation
* Instance health
* Application latency

Alarms are configured to detect abnormal behaviour.

---

## Compliance

While not aligned to a specific framework, the system follows AWS Well-Architected principles, particularly in security and reliability.

---

## Known Risks

* No Web Application Firewall (WAF) configured
* No encryption at rest for logs
* Basic IAM configuration

---

## Mitigations

* Use of private subnets reduces exposure
* Security groups restrict access
* Monitoring and alerts provide visibility

---

## Summary

The system implements fundamental cloud security controls appropriate for a non-production environment.
