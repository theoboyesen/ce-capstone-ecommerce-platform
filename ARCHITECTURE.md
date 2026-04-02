# Architecture

## Overview

The system is designed as a highly available, scalable web application deployed on AWS using Terraform. It follows a multi-tier architecture, separating public-facing components from private application resources.

---

## Architecture Flow

User → Application Load Balancer → Auto Scaling Group → EC2 Instances

---

## Components

### VPC

A custom VPC provides network isolation and contains both public and private subnets across multiple availability zones.

### Public Subnets

* Host the Application Load Balancer
* Allow inbound HTTP traffic from the internet

### Private Subnets

* Host EC2 instances
* No direct internet access

### NAT Gateway

Enables outbound internet access for EC2 instances in private subnets (e.g., for package installation).

### Application Load Balancer (ALB)

* Distributes incoming traffic across EC2 instances
* Performs health checks on `/health` endpoint

### Auto Scaling Group (ASG)

* Maintains a fixed number of instances (3)
* Ensures high availability across availability zones

### EC2 Instances

* Run a Node.js application
* Serve HTTP traffic on port 3000

---

## Data Flow

1. User sends request to the ALB
2. ALB routes request to a healthy EC2 instance
3. EC2 processes the request via the Node.js application
4. Response is returned to the user via the ALB

---

## High Availability

* Multi-AZ deployment
* Load balancing across instances
* Health checks with automatic instance replacement

---

### RDS (Database Layer)

- Managed relational database (RDS)
- Deployed in private subnets
- Not publicly accessible
- Used as the data persistence layer

---

## Scalability

* Auto Scaling Group maintains desired capacity
* Architecture supports future dynamic scaling policies
* Load balancer distributes traffic evenly

---

## Technology Choices

* **Terraform**: Infrastructure as Code for reproducibility
* **AWS EC2**: Compute layer
* **ALB**: Traffic distribution and health checks
* **CloudWatch**: Monitoring and alerting

---

## Trade-offs and Alternatives

* Fixed scaling simplifies configuration but limits flexibility
* NAT Gateway improves security but increases cost
* EC2 chosen over containers for simplicity

---

## Diagram

See `/docs/architecture/architecture-overview.png`
