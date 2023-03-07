 # Create a VPC
resource "aws_vpc" "jahir-devops4_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "jahir-devops4"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "jahir-devops4_igw" {
  vpc_id = aws_vpc.jahir-devops4_vpc.id
  tags = {
    Name = "jahir-devops4-igw"
  }
}

# Create public and private subnets
resource "aws_subnet" "jahir-devops4_public_subnet" {
  vpc_id = aws_vpc.jahir-devops4_vpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "eu-central-1a"
  map_public_ip_on_launch = true
  tags = {
    Name = "jahir-devops4-public-subnet"
  }
}

resource "aws_subnet" "jahir-devops4_private_subnet" {
  vpc_id = aws_vpc.jahir-devops4_vpc.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "eu-central-1b"
  tags = {
    Name = "jahir-devops4-private-subnet"
  }
}

# Create a Route Table
resource "aws_route_table" "jahir-devops4_rt" {
  vpc_id = aws_vpc.jahir-devops4_vpc.id
  tags = {
    Name = "jahir-devops4-rt"
  }
}

# Associate public subnet with Route Table
resource "aws_route_table_association" "jahir-devops4_public_subnet_rt_association" {
  subnet_id = aws_subnet.jahir-devops4_public_subnet.id
  route_table_id = aws_route_table.jahir-devops4_rt.id
}

# Create a Route for Internet Gateway
resource "aws_route" "jahir-devops4_igw_route" {
  route_table_id = aws_route_table.jahir-devops4_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.jahir-devops4_igw.id
}

# Outputs
output "jahir-devops4_vpc_id" {
  value = aws_vpc.jahir-devops4_vpc.id
}

output "jahir-devops4_public_subnet_id" {
  value = aws_subnet.jahir-devops4_public_subnet.id
}

output "jahir-devops4_private_subnet_id" {
  value = aws_subnet.jahir-devops4_private_subnet.id
}

resource "aws_security_group" "jahir-devops4_security_group" {
  name_prefix = "jahir-devops4_security_group"
  vpc_id = aws_vpc.jahir-devops4_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# create elb
resource "aws_elb" "jahir-devops4-elb" {
  name               = "jahir-devops4-elb"
  subnets            = [aws_subnet.jahir-devops4_public_subnet.id]
  security_groups    = [aws_security_group.jahir-devops4_security_group.id]
  
  listener {
    lb_port           = 80
    lb_protocol       = "http"
    instance_port     = 80
    instance_protocol = "http"
  }
}

#  create target group

resource "aws_lb_target_group" "jahir-devops4-tg" {
  name     = "jahir-devops4-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.jahir-devops4_vpc.id
}

#  create launching config
resource "aws_launch_configuration" "jahir-devops4-launch-configuration" {
  name = "jahir-devops4-launch-configuration"
  image_id = "ami-0c0933ae5caf0f5f9"
  instance_type = "t2.micro"
  user_data = <<EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install httpd -y
              sudo systemctl start httpd
              sudo systemctl enable httpd
              echo "<html><body><h1>Hello world</h1></body></html>" | sudo tee /var/www/html/index.html
              EOF
}

# create asg
resource "aws_autoscaling_group" "jahir_devops4_asg" {
  name = "jahir_devops4_asg"
  max_size = 3
  min_size = 1
  launch_configuration = aws_launch_configuration.jahir-devops4-launch-configuration.id
  health_check_type = "ELB"
  health_check_grace_period = 300
  desired_capacity = 2
  target_group_arns = [aws_lb_target_group.jahir-devops4-tg.arn]
  vpc_zone_identifier = [aws_subnet.jahir-devops4_public_subnet.id]
}
