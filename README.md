# Example IaC UPE

<p align="left">
    <img src="https://img.shields.io/badge/-Linux-000000.svg?style=for-the-badge&logo=Linux&logoColor=white"/>
    <img src="https://img.shields.io/badge/-Ansible-EE0000.svg?style=for-the-badge&logo=Ansible&logoColor=white"/>
    <img src="https://img.shields.io/badge/-docker-0db7ed.svg?style=for-the-badge&logo=docker&logoColor=white">
    <img src="https://img.shields.io/badge/-terraform-7B42BC.svg?style=for-the-badge&logo=terraform&logoColor=white">
    <img src="https://img.shields.io/badge/-AWS-ff9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white"/>
</p>

<p align="left">
  <a href="http://creativecommons.org/licenses/by-nc-sa/4.0/">
    <img src="https://img.shields.io/badge/-CC_BY--SA_4.0-000000.svg?style=for-the-badge&logo=creative-commons&logoColor=white"/>
  </a>
</p>

## Description
Project example to deploy a kind of "IaC hello world" to UPE talk.

The project create an AWS EC2 infrastructure and config a web server with nginx.

## Pre requirements
Set some environment variables.

```bash
# create a .env file with a new SSH public key and AWS env vars
./run --generate-env-file

# fill the AWS env vars, and fter run:
source .env
```

## Use:
```bash
# to create infra
./run.sh --create-infra

# to destroy infra
./run.sh --destroy-infra
```

----

  ### License:

<p align="center">
  <a rel="license" href="http://creativecommons.org/licenses/by-nc-sa/4.0/">
    <img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png" />
  </a>
</p>
