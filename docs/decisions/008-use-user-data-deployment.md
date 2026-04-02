# Decision: Use EC2 User Data for Application Deployment

## Context

The application needs to be deployed automatically when instances are launched.

## Decision

Use EC2 user_data scripts to install dependencies and start the application.

## Consequences

* Enables automated bootstrapping
* Simplifies deployment pipeline
* Can introduce timing and dependency issues during startup
