# TERRAFORM COMMAND

- check if terraform file is valid or not


```sh
terraform validate
```

> NOTE: The terraform apply failed in spite of our validation working! This is because the validate command only carries out a general verification of the configuration. It validated the resource block and the argument syntax but not the values the arguments expect for a specific resource!


- formating terraform code

```sh
terraform fmt
```

- show resource

```sh
terraform show -json

# option -json can be used to output result as a json format
```

- show provider list


```sh
terraform providers

```

- to show all output define in terraform file


```sh
terraform output
```

- refreshing state

```sh
terraform refresh
```

- to show plan (what will be affect after running)

```sh
terraform plan
```
 
 - to show visual representation 

```sh
terraform graph
```
> tips: to get visual represent of graph using any graph visualising software (in ubuntu for example)
![image](https://user-images.githubusercontent.com/39403552/224932979-283d6a47-8ad4-4291-9dc0-7d5669327802.png)



- to apply all changes

```sh
terraform apply
```

- to destroy

```sh
terraform destroy
```

