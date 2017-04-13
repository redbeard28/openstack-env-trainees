# Ansible /bin/sh: 1: /usr/bin/python: not found

## Solution: To get your ansible working you have to do two things as given below.

### 1. Install python 2.x in remote server.

 In Ubuntu/Debian system
```bash
   sudo apt-get update
   sudo apt-get install python2.7
```
### 2. Set the ‘ansible_python_interpreter’ in inventory file at Ansible Server.
Given below is sample from my inventory file.

```bash
[all:vars]
   ansible_python_interpreter=/usr/bin/python2.7
```

After doing above steps. All gone successfully well. Here is the result.

```bash
redbeard28@stormtrooper:~$ ansible -i inventory/hosts -m ping
192.168.199.5 | SUCCESS => {
    "changed": false, 
    "ping": "pong"
}

192.168.199.10 | SUCCESS => {
    "changed": false, 
    "ping": "pong"
```