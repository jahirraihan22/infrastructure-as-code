# ANSIBLE BASIC UNDERSTANDING

## ANSIBLE INVENTORY

```yaml

# Sample Inventory File
  
# Web Servers
web_node1 ansible_host=web01.xyz.com ansible_connection=winrm ansible_user=administrator ansible_password=Win$Pass
web_node2 ansible_host=web02.xyz.com ansible_connection=winrm ansible_user=administrator ansible_password=Win$Pass
web_node3 ansible_host=web03.xyz.com ansible_connection=winrm ansible_user=administrator ansible_password=Win$Pass

# DB Servers
sql_db1 ansible_host=sql01.xyz.com ansible_connection=ssh ansible_user=root ansible_ssh_pass=Lin$Pass
sql_db2 ansible_host=sql02.xyz.com ansible_connection=ssh ansible_user=root ansible_ssh_pass=Lin$Pass




# Groups
[db_nodes]
sql_db1
sql_db2

[web_nodes]
web_node1
web_node2
web_node3

[boston_nodes]
sql_db1
web_node1

[dallas_nodes]
sql_db2
web_node2
web_node3

[us_nodes:children]
boston_nodes
dallas_nodes

```
> ansible_os_family is the Ansible built-in variable that populates the flavour of the operating system.


## Modules

## Functions

## Variables

## Conditionals

```yml

- name: Install package
  hosts: app1
  tasks:
    - name: Install
      package:
        name: vim
        state: present
      when: ansible_os_family != "RedHat"

```

```yml

-  name: 'Execute a script on all web server nodes'
   hosts: all
   become: yes
   tasks:
     -  service: 'name=nginx state=started'
         when: 'ansible_host=="node02"'

```

```yml


---
- name: 'Am I an Adult or a Child?'
  hosts: localhost
  vars:
    age: 25
  tasks:
    - name: I am a Child
      command: 'echo "I am a Child"'
      when: 'age < 18'
    - name: I am an Adult
      command: 'echo "I am an Adult"'
      when: 'age >= 18'
      
 ```
 ## Loops 
  - look up plugins 

![image](https://user-images.githubusercontent.com/39403552/225590122-540e848a-f42d-47f5-ae95-3d0534a41559.png)

#### This playbook currently runs an `echo` command to print a fruit name. Applying a loop directive (with_items) to the task to print all fruits defined under the fruits variable.


```yaml

-  name: 'Print list of fruits'
   hosts: localhost
   vars:
     fruits:
       - Apple
       - Banana
       - Grapes
       - Orange
   tasks:
     - command: 'echo "{{ item }}"'
       with_items: "{{ fruits }}"

```

#### The playbook installs packages

``` yaml

- name: 'Install required packages'
  hosts: localhost
  become: yes
  vars:
    packages:
      - httpd
      - make
      - vim
  tasks:
    - yum:
        name: '{{ item }}'
        state: present
      with_items: '{{ packages }}'

```
 
