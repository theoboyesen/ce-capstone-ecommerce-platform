# Architecture

## Overview

The system is designed as a multi-tier architecture on AWS, focusing on high availability, scalability, and security.

Traffic flows through a public load balancer into a private application layer.

## Architecture Flow

User → Application Load Balancer → Auto Scaling Group → EC2 Instances

## Components

### VPC

* Custom VPC with public and private subnets
* Multi-AZ deployment for resilience

### Public Subnets

* Host the Application Load Balancer
* Internet-facing

### Private Subnets

* Host EC2 instances
* No direct public access

### NAT Gateway

* Enables outbound internet access for private instances

### Application Load Balancer

* Distributes traffic across EC2 instances
* Performs health checks on `/health`

### Auto Scaling Group

* Maintains 3 EC2 instances across AZs
* Ensures high availability

### EC2 Instances

* Run a Node.js application
* Serve application traffic on port 3000

## High Availability

* Multi-AZ deployment
* Load balancing across instances
* Health checks with automatic replacement

## Diagram

See `/docs/architecture/architecture-overview.png`
