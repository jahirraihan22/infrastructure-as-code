# TERRAFORM

Terraform is an open-source infrastructure as code (IAC) tool that allows developers to manage their infrastructure through code. With Terraform, developers can create, manage, and modify infrastructure resources across multiple cloud providers, such as AWS, GCP, and Azure. In this article, we'll take a look at the basic syntax of Terraform and some common use cases.

### Installing Terraform on Linux
- Download the latest version of Terraform from the official website: https://www.terraform.io/downloads.html

- Extract the downloaded zip file to a directory of your choice:

```sh
unzip terraform.zip -d /usr/local/bin/
```
- Verify that the installation was successful by running the following command:

```sh
terraform --version
```
### Basic Terraform Commands
Some basic Terraform commands that you can use to manage your infrastructure:

`terraform init` : Initializes a new or existing Terraform working directory. This command downloads the required provider plugins and sets up the backend.

`terraform plan`: Creates an execution plan that shows what changes will be made to the infrastructure. This command shows the difference between the current state and the desired state of the infrastructure.

`terraform apply`: Applies the changes to the infrastructure. This command makes the necessary changes to the infrastructure to bring it in line with the desired state.

`terraform destroy`: Destroys all the resources that were created by Terraform. This command removes all the resources that were created by Terraform.

`terraform state list`: Lists all the resources that are being managed by Terraform. This command shows the current state of the infrastructure.

`terraform show`: Shows the current state of the infrastructure in a human-readable format.


### Basic Syntax
Terraform uses a declarative syntax to define infrastructure resources. Instead of describing how to create each individual resource, Terraform allows developers to define the desired state of their infrastructure. Terraform then compares the desired state with the current state and makes the necessary changes to bring the infrastructure in line with the desired state.

The basic syntax of Terraform consists of three main components:

#### Providers
Providers are plugins that Terraform uses to interact with various cloud providers. For example, the AWS provider allows Terraform to interact with AWS resources. To use a provider, you must define it in your Terraform configuration file.

```tf
provider "aws" {
  region = "us-west-2"
}
```

This example configures the AWS provider to use the us-west-2 region.

#### Resources
Resources are the infrastructure objects that you want to create or manage. Resources are defined in Terraform configuration files using the following syntax:

```tf
resource "resource_type" "resource_name" {
  # Resource arguments
}
```

For example, to create an EC2 instance in AWS, you can define the following resource:

```tf

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
}
```

#### Variables

Variables are used to parameterize your Terraform configuration files. They allow you to define values that can be passed into your Terraform scripts at runtime. You can define variables in Terraform using the following syntax:

```tf
variable "variable_name" {
  # Variable arguments
}
```
For example, to define a variable that represents an AWS region, you can define the following variable:

```tf

variable "region" {
  default = "us-west-2"
}
```
You can then use this variable in your resource definitions, like this:

```tf

resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  region        = var.region
}
```
Here you can find in [main.tf](./main.tf) a basic terraform code which task is to,
- Develop a Terraform module that sets up an Amazon VPC - devops4 with public and private subnets and an Internet Gateway for Internet access.
- Build a Terraform module that sets up an Amazon Elastic Load Balancer and associated Auto Scaling Group for high availability.

### Use Cases
Terraform can be used to manage a wide range of infrastructure resources, from virtual machines and containers to databases and load balancers. Here are some common use cases for Terraform:

#### Cloud Resource Management
Terraform can be used to create and manage cloud resources such as virtual machines, databases, and storage buckets. By defining infrastructure resources in code, developers can automate the creation and management of these resources, making it easier to maintain consistency and manage change.

#### Continuous Deployment
Terraform can be used to automate the deployment of infrastructure changes as part of a continuous deployment pipeline. By integrating Terraform with tools such as Jenkins or GitLab CI/CD, developers can automate the deployment of infrastructure changes alongside application code changes.

#### Multi-Cloud Management
Terraform can be used to manage infrastructure resources across multiple cloud providers. By defining resources in a single configuration file, developers can manage resources across AWS, GCP, and Azure, making it easier to maintain consistency and avoid vendor lock-in.


