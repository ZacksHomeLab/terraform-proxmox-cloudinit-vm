---
name: Bug report
about: Create a report to help us improve
labels: bug
assignees: ZacksHomeLab
---

## Description
Please provide a detailed and concise description of the issue you are facing. Additionally, include a reproduction of your configuration. If you are unable to provide your exact configuration, you can refer to the `examples/*` directory for references that can be copied, pasted, and customized to match your configurations. It is essential that the reproduction provided can be executed successfully by running `terraform init && terraform apply` without any additional modifications.

If your request is for a new feature, please use the `Feature request` template.

## ⚠️ Note ⚠️

**Before you submit an issue, please perform the following:**

- [ ] (**ONLY** if you store your state remotely) I have removed the local `.terraform` directory. This step is to insure you've re-initializing this module.
- [ ] I have re-initialized the project via `terraform init`.
- [ ] I have tried multiple times to run `terraform plan` and `terraform apply`, but the issue still persists.

## Versions 

- (Required) Module Version: 

- Terraform Version:
<!-- Execute command: terraform -version --> 
- (Optional) Terragrunt Version:
<!-- Execute command: terragrunt -version --> 
- Provider(s) Version: 
<!-- Execute command: terraform providers -version -->

## Reproduction Code [Required]

<!-- REQUIRED -->

Steps to reproduce the behavior:

<!-- Are you using workspaces? -->
<!-- Have you cleared the local cache (see Notice section above)? -->
<!-- List steps in order that led up to the issue you encountered -->

## Expected behavior

<!-- A clear and concise description of what you expected to happen -->

## Actual behavior

<!-- A clear and concise description of what actually happened -->

### Terminal Output Screenshot(s)

<!-- Optional but helpful -->

## Additional context

<!-- Add any other context about the problem here -->