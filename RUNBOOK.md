# Runbook

## Overview

This runbook provides guidance on deploying, operating, and troubleshooting the system.

---

## Deployment

### Deploy Infrastructure

```bash
terraform init
terraform apply
```

---

### Destroy Infrastructure

```bash
terraform destroy
```

---

## Application Health

Check application:

http://<alb-dns>/health

Expected response: OK

---

## Monitoring

* CloudWatch dashboard provides system metrics
* Alarms notify on high CPU, unhealthy instances, and latency

---

## Troubleshooting

### 502 Bad Gateway

Possible causes:

* Application not running
* Node.js installation failure

Actions:

* Check EC2 system logs
* Verify user_data execution

---

### Unhealthy Targets

Possible causes:

* Health check endpoint not responding
* Incorrect port configuration

Actions:

* Verify `/health` endpoint
* Ensure app listens on port 3000

---

### High CPU Usage

Actions:

* Review CloudWatch metrics
* Consider scaling or instance type changes

---

## Incident Response

1. Identify issue via CloudWatch alarms
2. Check target group health
3. Review logs
4. Replace instances if necessary

---

## Backup and Recovery

* Infrastructure is defined in Terraform and can be recreated
* No persistent data storage is used

---

## Scaling

To adjust capacity, update Terraform configuration:

terraform apply
