#### points to note about Terraform Variables

1. we can pass from cmd i.e., `terraform plan -var=instance_type="t2.nano"`.

2. create new terraform.tfvars file and declare the variables, and just run `terraform plan`.

3. Terraform will always load variables listed in the `terraform.tfvars` file.

4. For additional variables, we can use `<any_name>.tfvars` but these will not be autoloaded.

5. we can save the additional variables also with `<any_name>.auto.tfvars` to always load them; Usually it's used if the `terraform.tfvars` file is already a large file and we want to split them to separate files and to manage smoothly.

6. `terraform plan -var-file dev.tfvars` to specify variables inlines via the command line.

7. Terraform will watch for environment variables that beign with `TF_VAR_` and apply those as variables. eg: `TF_VAR_my_variable_name`.

8. we can override the variables and the order of precedence is below - `-var and -var-file > *.auto.tfvars or *.auto.tfvars.json > terraform.tfvars.json > terraform.tfvars > Environment Variables`.