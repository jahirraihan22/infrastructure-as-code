### EXAMPLE OF RESOURCE

```tf

resource "tls_private_key" "pvtkey" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "local_file" "key_details" {
    content = tls_private_key.pvtkey.private_key_pem
    filename = "/root/key.txt"
}

```

``` tf

resource "local_file" "whale" {
  filename = "/root/whale"
  content = "whale"
  depends_on = [local_file.krill]
}

resource "local_file" "krill" {
  filename = "/root/krill"
  content = "krill"
}


```
