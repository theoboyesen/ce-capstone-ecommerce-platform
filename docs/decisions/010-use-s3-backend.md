# Decision: Use S3 for Terraform Remote State

## Context

Terraform state needs to be shared and persisted securely.

## Decision

Store Terraform state in an S3 bucket.

## Consequences

* Enables collaboration and state persistence
* Reduces risk of local state loss
* Requires proper access control
