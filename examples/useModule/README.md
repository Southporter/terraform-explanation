# Using Modules

This folder contains some terraform files for utilizing modules.

You will need to set up your own state bucket. Rename the bucket in `state.tf` to your bucket and modify the key to your liking.

If you modify the `examples/account/us-east-1.tfvars` and `examples.tfvars` file to match resources in your environment, then you can run the following:

```bash
terraform plan -var-file=../account/us-east-1.tfvars -var-file=examples.tfvars
```

You will see the resources that terraform would create if you ran the following:

```bash
terraform apply -var-file=../account/us-east-1.tfvars -var-file=examples.tfvars
```

