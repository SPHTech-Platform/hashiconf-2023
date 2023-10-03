# HashiConf 2023 Demo Repository

This is the companion repository to our HashiConf 2023 session
[Transforming into a modern era of developer environments with service mesh](https://hashiconf.com/2023/sessions/san-francisco/transforming-into-a-modern-era-of-developer-environments-with-service-mesh).

It contains the Terraform code we have used to provision the demo environment.

A few things to note:

- This repository is provided "as-is" without warranty or support.
- We do not provide support via Issues or other channels.
- We do not accept pull requests.
- This code is **not production ready** and only meant to demonstrate our proof of concept.

> Note: There is some remnants of Hashicup which we ran out of time getting working. Please disregard them.

## Pre-requisites

- Hashicorp Cloud Platform (HCP) account
- One or more AWS accounts

It is possible to provision everything in one account, or multiple accounts. Tweak the credentials
for your AWS providers accordingly.

## Usage

The setup is broken down into three separate modules which must be provisioned in order. This is
because many resources are created and combining into one giant module will cause dependencies
issues with Terraform.

- `base`
- `admin_partition`
- `app`

Refer to the `examples` directory for how to use these modules.

### `base` module

The `base` module provisions the basics of our setup, including:

- Networking, including the routeable and non-routeable setup with Transit Gateway
- HCP Consul Cluster
- HCP Vault Cluster
- RDS instance

### `admin_partition` module

The second module creates the following:

- Admin Partitions and ACL
- EKS cluster with Consul Data plane

### `app` module

The third and final module creates the following:

- Applications for service to service communication
- Vault database secrets engine configuration to RDS
