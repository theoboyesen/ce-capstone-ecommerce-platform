# Runbook

## Overview

This document outlines how to operate and troubleshoot the system.

---

## Common Operations

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

## Health Checks

Check application:

```
http://<alb-dns>/health
```

Expected response: OK

---

## Troubleshooting

### 502 Bad Gateway

Possible causes:

* Application not running
* Node.js failed to install

Actions:

* Check EC2 system logs
* Verify user_data execution

---

### Unhealthy Targets

Possible causes:

* Health check path incorrect
* App not responding on port 3000

Actions:

* Confirm `/health` endpoint
* Check application logs

---

### High CPU Alert

Actions:

* Review CloudWatch metrics
* Consider scaling or instance type adjustment

---

## Logs

Application logs are available in CloudWatch under:

capstone-app-logs

---

## Recovery

If system becomes unstable:

```bash
terraform apply -replace=module.compute.aws_autoscaling_group.app_asg
```
