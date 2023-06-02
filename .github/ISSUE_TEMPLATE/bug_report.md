---
name: Bug report
about: Create a report to help us improve
title: "[BUG]"
labels: bug
assignees: ZacksHomeLab

---

## Description
Please provide a detailed and concise description of the issue you are facing. Additionally, include a reproduction of your configuration. If you are unable to provide your exact configuration, you can refer to the `examples/*` directory for references that can be copied, pasted, and customized to match your configurations. It is essential that the reproduction provided can be executed successfully by running `terraform init && terraform apply` without any additional modifications.

If your request is for a new feature, please use the `Feature request` template.

**Before you submit an issue, please perform the following:**

- [ ] (**ONLY** if you store your state remotely) I have removed the local `.terraform` directory. This step is to insure you're re-initializing this module.
- [ ] I have re-initialized the project via `terraform init`.
- [ ] I have tried multiple times to run `terraform plan` and `terraform apply`, but the issue still persists.

## Versions 

- (Required) Module Version: 
- Terraform Version (`terraform -version`): 
- (Optional) Terragrunt Version (`terragrunt -version`):
- Provider Version (`terraform providers -version`): 

## Required: Steps to Reproduce

**Sample Code**

Please provide the sample code that triggered said issue:

```

```

**Steps to Reproduce Issue**

List steps in order that led up to the issue you encountered.

## Expected behavior

A clear and concise description of what you expected to happen.

## Actual behavior

A clear and concise description of what actually happened.

## Optional: Terminal Output / Screenshots

If you can, please provide the terminal output that you've received. You may need to enable debugging by running `export TF_LOG=trace`. 

## Additional Comments

Any other comments regarding your issue, please post them here.
