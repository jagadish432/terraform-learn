-> 
`terraform init` to download provider and setup. it's also used to install modules when needed

`terraform fmt` to format the code

`terraform validate` to validate the syntax (It's included in `terraform plan`)

`terraform plan` to show what the current config will do i.e., what resources it will create, delete, modify..

`terraform apply` Apply the shown changes to the provider


-> ```Variables```

1. we can pass from cmd i.e., `terraform plan -var=instance_type="t2.nano"`

2. create new terraform.tfvars file and declare the variables, and just run `terraform plan`


-> 

`terraform refresh` to refresh the values of exisitng/new variables using existing data/resources.

`terraform output` to display all output variables with values

`terraform apply -auto-approve` to skip asking for "enter yes to approve"


-> We can also use 2 providers for 2 different regions (will need to check if possible with 2 different clouds)

-> We can also provider specific provider to be used for specific module

->
`terrform apply -destroy` or `terraform destroy` to delete all resources


->
As terraform doesn't create any AWS CF stacks or any cloud similar stack. Terraform stores its state in .tfstate files and we can backup them in terraform cloud if needed.

