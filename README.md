# E-Commerce Cloud Platform (Capstone Project)

## Overview
This project is a production-ready cloud platform built using Terraform on AWS. It demonstrates a scalable, secure, and automated multi-tier architecture designed to simulate real-world cloud engineering practices.

The platform allows users to access an application via a load balancer, while the backend infrastructure is designed to be highly available, fault-tolerant, and cost-efficient.

---

## Architecture

The platform follows a multi-tier architecture:

- **Public Tier**
  - Application Load Balancer (ALB)
  - Handles incoming internet traffic

- **Private Tier**
  - EC2 instances managed by an Auto Scaling Group
  - Application runs securely without direct internet exposure

- **Networking**
  - VPC with public and private subnets across multiple Availability Zones
  - NAT Gateway enables outbound internet access for private resources

---

## Infrastructure as Code

- Built using **Terraform**
- Modular structure for reusability and clarity:
  - `networking` module (VPC, subnets, routing)
  - `compute` module (EC2, ALB, Auto Scaling)
- Remote state stored in **S3** for consistency and team collaboration

---

## CI/CD Pipeline

Implemented using **GitHub Actions**:

- Pull Requests trigger:
  - `terraform plan` (safe preview of changes)

- Merges to `main` trigger:
  - `terraform apply` (deploy infrastructure)

This ensures safe, controlled, and auditable infrastructure changes.

---

## Security

Security was implemented using a **defence-in-depth approach**:

- EC2 instances deployed in **private subnets**
- No direct internet access to application instances
- Security groups enforce **least privilege access**:
  - ALB allows inbound traffic from the internet
  - EC2 instances only accept traffic from the ALB

---

## Monitoring and Observability

- **CloudWatch Dashboard** for visibility into infrastructure metrics
- **CloudWatch Alarm** configured to trigger when CPU utilisation exceeds threshold

This enables proactive monitoring and system health awareness.

---

## Cost Optimisation

- Used **t3.micro instances** (AWS Free Tier eligible)
- Minimal infrastructure footprint while maintaining scalability
- Auto Scaling ensures efficient resource usage based on demand

---

## Key Design Decisions

- **Multi-tier architecture** to separate concerns and improve scalability
- **Auto Scaling Group** to handle varying traffic loads
- **Security group referencing** to enforce strict access control between tiers
- **CI/CD pipeline** to automate and standardise deployments
- **Remote state management** to prevent configuration drift and enable collaboration

---

## How to Deploy

```bash
terraform init
terraform plan
terraform apply
```

## Future Improvements

- Add database tier (RDS) for full 3-tier architecture
- Implement HTTPS with ACM and TLS termination
- Containerisation using Docker and ECS/EKS
- Add WAF for enhanced security

