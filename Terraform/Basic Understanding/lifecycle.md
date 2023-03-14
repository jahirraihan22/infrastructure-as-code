# SOME EXAMPLE OF RESOURCE LIFECYCLE

```tf
resource "random_pet" "super_pet" {
    length = var.length
    prefix = var.prefix
    lifecycle {
      prevent_destroy = true
    }
}

```

```tf
resource "random_pet" "super_pet" {
    length = var.length
    prefix = var.prefix
    lifecycle {
      ignore_changes = [
        length,
        prefix
      ]
    }
}

```


```tf
resource "random_pet" "super_pet" {
    length = var.length
    prefix = var.prefix
    lifecycle {
      create_before_destroy = false
    }
}

```


![image](https://user-images.githubusercontent.com/39403552/224966910-9a8cd6c2-40c6-4a9b-a66b-e3683af8be93.png)
