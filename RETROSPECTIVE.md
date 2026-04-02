# Retrospective

## Overview

This project involved designing and deploying a production-style AWS infrastructure using Terraform.

---

## What Went Well

* Successfully implemented a multi-tier architecture
* Deployed a working load-balanced application
* Configured monitoring and alerting

---

## Challenges

### Node.js Compatibility Issue

Node.js 18 failed due to system library incompatibility.

Resolution:
Switched to Node.js 16.

---

### Application Startup Issues

Application failed to start due to script execution order.

Resolution:
Ensured application starts before additional services.

---

### Debugging Complexity

Difficulty distinguishing infrastructure vs application issues.

Resolution:
Used logs and health checks to isolate root causes.

---

## Technical Skills Learned

* Terraform infrastructure design
* AWS networking and load balancing
* Debugging deployment issues
* Monitoring and alerting setup

---

## Key Takeaways

* Logs should guide debugging
* Infrastructure and application issues must be separated
* Small misconfigurations can have large impacts

---

## What Would Be Improved

* Implement dynamic auto scaling
* Use containerisation (Docker)
* Add automated testing

---

## Future Improvements

* CI/CD pipeline enhancements
* More advanced monitoring
* Improved security controls

---

## Conclusion

This project provided practical experience with real-world cloud infrastructure challenges and improved problem-solving skills.
