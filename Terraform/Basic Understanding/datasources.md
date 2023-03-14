# DATASOURCES


![image](https://user-images.githubusercontent.com/39403552/224982993-ec73dec8-36a3-4047-b5c6-08a34c0a0d8a.png)


```tf

output "os-version" {
  value = data.local_file.os.content
}
data"local_file" "os" {
  filename = "/etc/os-release"
}

```


![image](https://user-images.githubusercontent.com/39403552/224982734-c0e5fc61-f0c8-4a3d-b564-d8a46e49df54.png)
