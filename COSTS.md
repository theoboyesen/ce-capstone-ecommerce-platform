# Costs

## Monthly Cost Breakdown

* EC2 (3 × t3.micro): $25–30
* Application Load Balancer: $18–20
* NAT Gateway: $30–35

Estimated total: $70–90 per month

---

## Cost Allocation

Resources are tagged with:

* Project
* Environment
* Owner

These tags enable cost tracking and allocation.

---

## Cost Optimisation Strategies

* Use of small instance types (t3.micro)
* Infrastructure destroyed when not in use
* Fixed scaling for predictable cost
* Efficient load balancing

---

## Trade-offs

* Smaller instances reduce cost but limit performance
* NAT Gateway increases cost but improves security
* Fixed scaling reduces flexibility

---

## Scaling Cost Projection

Increasing instance count will proportionally increase EC2 costs, while ALB and NAT Gateway costs remain relatively stable.

---

## Reserved Instances

Reserved instances could reduce EC2 costs for long-running environments.

---

## Budget Alerts

CloudWatch alarms are used for operational monitoring. AWS Budgets could be configured for cost-specific alerts.

---

## Summary

The system balances cost and performance, prioritising simplicity and predictability.
