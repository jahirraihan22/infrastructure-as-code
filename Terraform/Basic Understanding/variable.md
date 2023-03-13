# TERRAFORM VARIABLES

### TYPES

![image](https://user-images.githubusercontent.com/39403552/224646133-bdc4ea07-99ac-4482-b941-06701cf99576.png)

### variables.tf

```tf

variable "name" {
     type = string
     default = "Mark"
  
}
variable "number" {
     type = bool
     default = true
  
}
variable "distance" {
     type = number
     default = 5
  
}
variable "jedi" {
     type = map
     default = {
     filename = "/root/first-jedi"
     content = "phanius"
     }
  
}

variable "gender" {
     type = list(string)
     default = ["Male", "Female"]
}
variable "hard_drive" {
     type = map
     default = {
          slow = "HHD"
          fast = "SSD"
     }
}
variable "users" {
     type = set(string)
     default = ["tom", "jerry", "pluto", "daffy", "donald", "chip", "dale"]

  
}
```
  
### main.tf

```tf

resource "local_file" "jedi" {
     filename = var.jedi["filename"]
     content = var.jedi["content"]
}


```

### PRECEDENCE OF VARIABLE

![image](https://user-images.githubusercontent.com/39403552/224663799-80c967d0-9228-4452-b341-ee1c7597c775.png)


- Environment variables: Terraform will first check for the presence of environment variables with names matching your variable names, using the prefix TF_VAR_. For example, if you have a variable called region, Terraform will look for an environment variable called TF_VAR_region.

- Command-line options: You can pass in variable values using command-line options, like -var="region=us-west-2". These values will override any values defined in other variable files or in your configuration files.

- terraform.tfvars or .auto.tfvars: Terraform will automatically load variable values from files with these names in your working directory. If you have both terraform.tfvars and .auto.tfvars files, Terraform will load the values from both files, with .auto.tfvars taking precedence.

- -var-file option: You can pass in a file containing variable values using the -var-file option, like -var-file="variables.tfvars". This file will be loaded after terraform.tfvars and .auto.tfvars, so values in the file will override any values defined in those files.

- Variable definitions in your configuration files: If you define a variable directly in your configuration files using the variable keyword, Terraform will use that value if no other values have been provided.
