# VERSIONIN OF REASOURCE


```tf


terraform {
  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "1.2.2"
    }
  }
}

resource "local_file" "innovation" {
  filename = var.path
  content  = var.message
}



```


``` tf

terraform {
  required_providers {
    k8s = {
      source  = "hashicorp/kubernetes"
      version = "> 1.12.0, != 1.13.1, < 1.13.3 "
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 1.2.0"
    }
  }
}


```

```tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "!=1.3.0"
    }
  }
}

resource "aws_ebs_volume" "soft-volume" {
  availability_zone = "us-west-2a"
  size              = 15
  tags = {
    Name = "temporary"
  }
}

```
```tf

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "> 3.45.0, !=3.46.0, < 3.48.0"
    }
  }
}

resource "google_compute_instance" "special" {
  name         = "aone"
  machine_type = "e2-micro"
  zone         = "us-west1-c"

}


```
