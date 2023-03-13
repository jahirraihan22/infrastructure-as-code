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




