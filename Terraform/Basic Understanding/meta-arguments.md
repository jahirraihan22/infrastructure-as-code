# META ARGUMENTS

## count


``` tf
  
  resource "local_file" "pet" {
    filename = var.filename
    
    count = 3
  }

```

``` tf

variable "filename" {
  
  default = [
    "/root/pets.txt",
    "/root/dogs.txt",
    "/root/cats.txt",
    "/root/cows.txt",
  
  ]

}


```

```sh
ls /root

# output will be
# pets.txt
# cats.txt
# dogs.txt

```

![image](https://user-images.githubusercontent.com/39403552/224987944-2041f0a8-61b7-4896-aa7c-23fc33c6507e.png)


> we can use `length()` for variables count

``` tf
  
  resource "local_file" "pet" {
    filename = var.filename[count.index]
    
    count = length(var.filename)
  }

```

```sh
ls /root

# output will be
# pets.txt
# cats.txt
# dogs.txt
# cows.txt

```



## for-each

```tf

resource "local_file" "name" {
    filename = each.value
    for_each = toset(var.users)

    sensitive_content = var.content
}


```


```tf

variable "users" {
    type = list(string)
    default = [ "/root/user10", "/root/user11", "/root/user12", "/root/user10"]
}
variable "content" {
    default = "password: S3cr3tP@ssw0rd"
  
}


```

