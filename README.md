# AWS Cloud Infrastructure Capstone Project

## Overview

This project demonstrates the design and deployment of a production-style cloud infrastructure on AWS using Terraform. The system is designed with high availability, scalability, and observability in mind.

It consists of a load-balanced application running on EC2 instances within private subnets, managed by an Auto Scaling Group and monitored using CloudWatch.

---

## Architecture

The application follows a multi-tier architecture:

User → Application Load Balancer → Auto Scaling Group → EC2 Instances (Node.js)

### Key Components

* **VPC** with public and private subnets across multiple Availability Zones
* **Application Load Balancer (ALB)** to distribute incoming traffic
* **Auto Scaling Group (ASG)** maintaining three EC2 instances
* **EC2 instances** running a Node.js application
* **NAT Gateway** to allow outbound internet access from private subnets

---

## Application

A lightweight Node.js application is deployed on each EC2 instance.

### Endpoints

* `/`
  Returns instance metadata:

```json
{
  "instance_id": "...",
  "availability_zone": "...",
  "status": "healthy"
}
```

* `/health`
  Returns a 200 OK response and is used by the load balancer for health checks.

---

## Features

* Infrastructure as Code using Terraform
* Multi-AZ deployment for high availability
* Load balancing with health checks
* Auto Scaling Group for instance management
* Secure architecture with no direct public access to EC2
* CloudWatch monitoring and alerting
* Centralised logging using CloudWatch Logs

---

## Monitoring and Observability

CloudWatch is used to provide visibility into system performance and health.

### Dashboard Metrics

* EC2 CPU utilisation
* ALB request count
* Healthy host count

### Alerts

* High CPU utilisation
* Unhealthy host count
* High response time

### Logging

Application logs are collected from EC2 instances and sent to CloudWatch Logs for centralised monitoring.

---

## Cost Optimisation

### Estimated Monthly Cost

* EC2 (3 × t3.micro): approximately $25–30
* Application Load Balancer: approximately $18–20
* NAT Gateway: approximately $30–35

Estimated total: $70–90 per month (region and usage dependent)

### Strategies

* Use of t3.micro instances to minimise compute costs
* Infrastructure is destroyed when not in use to avoid unnecessary charges
* Private subnets used to reduce exposure and unnecessary data transfer
* Fixed Auto Scaling capacity to maintain predictable costs

### Trade-offs

* Smaller instance types reduce cost but limit performance under high load
* NAT Gateway provides secure outbound access but is a significant cost component
* Fixed scaling improves cost predictability but reduces flexibility compared to dynamic scaling

---

## Challenges and Solutions

### Node.js Compatibility

Node.js 18 failed to install on Amazon Linux 2 due to a glibc version mismatch.

**Solution:**
Switched to Node.js 16, which is compatible with the base AMI.

---

### Application Startup Issues

The application initially failed to start due to timing issues in the EC2 bootstrap process.

**Solution:**
Reordered the user data script to ensure the application starts before additional services such as the CloudWatch agent.

---

### Debugging Infrastructure vs Application

It was initially unclear whether issues were caused by infrastructure or application configuration.

**Solution:**
Used EC2 system logs and ALB health checks to isolate the issue to the application layer.

---

## Deployment

### Prerequisites

* AWS account
* Terraform installed
* AWS CLI configured

### Steps

```bash
terraform init
terraform apply
```

---

## Testing

The application can be tested via the load balancer endpoint:

- `/` returns instance metadata
- `/health` returns a 200 OK response

Refreshing the root endpoint demonstrates load balancing across instances.


---

## Screenshots

Include the following screenshots in a `screenshots/` directory:

* Application response via ALB
* Load balancing across instances
* Target group health status
* CloudWatch dashboard
* CloudWatch alarms

---

## Key Learnings

* Designing scalable infrastructure using Terraform
* Implementing load balancing and health checks
* Managing remote state and infrastructure lifecycle
* Debugging real-world deployment issues
* Implementing monitoring and alerting in AWS

---

## Project Status

Infrastructure deployed, application running, and monitoring configured.

## Author

Theo Boyesen  
Capstone project for Ironhack Cloud Engineering bootcamp

