# Retrospective

## Overview

This project involved designing and deploying a production-style AWS infrastructure using Terraform.

---

## What Went Well

* Successfully implemented a multi-tier architecture
* Built a working load-balanced and auto-scaled application
* Implemented monitoring and alerting with CloudWatch

---

## Challenges

### Node.js Compatibility Issue

Node.js 18 failed to install due to incompatibility with Amazon Linux 2.

Resolution:
Switched to Node.js 16 which resolved the issue.

---

### Application Startup Failures

The application failed to start due to user_data execution timing.

Resolution:
Reordered the script to ensure the application starts before additional services.

---

### Debugging Complexity

Distinguishing between infrastructure and application issues was initially difficult.

Resolution:
Used system logs and health checks to isolate the issue.

---

## Key Learnings

* Importance of debugging using logs rather than guessing
* Understanding dependency compatibility in cloud environments
* Separation of infrastructure and application concerns
* Real-world complexity of deployment pipelines

---

## What I Would Improve

* Use containerisation for more consistent deployments
* Implement dynamic auto scaling policies
* Improve CI/CD pipeline with automated testing

---

## Conclusion

This project provided hands-on experience with real-world cloud infrastructure challenges and significantly improved debugging and problem-solving skills.
