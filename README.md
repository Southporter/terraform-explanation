# Teaching Terraform
### Purpose
This repository is designed to help explain the various parts of terraform,
including how to divvy up files and store state.

The main focus here will be AWS. This is because the only cloud platform
that I am currently familiar with is AWS. PRs are welcome to show other 
cloud platforms.


### Intro
Terraform is an Infrastructure as Code (IaC) tool for managing cloud resources.
Configured correctly, it will build out and tear down cloud resources in a 
reproducible manner.

##### Impotency

Terraform is idempotent. In layman's terms, this means that the code you write is the final state you wish to achieve. It is not additive. You can run `terraform apply` any number of times and you will get the same result.





### Tools

##### Managing Versions

I highly recommend using [tfenv](https://github.com/tfutils/tfenv). This let's you easily install, delete, and otherwise manage versions of the terraform cli. This is helpful when you are trying to update to a new version, but want to keep the old version to fall back on.

I would pair this with a `versions.tf` file in each directory in which you run the cli. The `versions.tf` file is used to specify the versions of the terraform cli this code requires. This is extremelly useful when you have some people on your team who don't use terraform as frequently and might accidentally be on a new verison.

Terraform state is **NOT** backwards compatible, even with in minor versions. So you cannot operate on `0.12.9` state with version `0.12.5` of the cli. So having a versions file to lock it down to `0.12.5` will save you a lot of headache.

##### Remote State

If you have more than one person/machine deploying code or have more than one environment to which you are deploying, I would strongly recommend setting up remote state and utilizing [workspaces](https://www.terraform.io/docs/state/workspaces.html).

Workspaces allow you to deploy the exact same infrastructure in multiple places without duplicating code. Pair that with environment specific variables files and you are ready to go.