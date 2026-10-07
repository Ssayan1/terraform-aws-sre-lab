# Terraform AWS SRE Lab

![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?logo=terraform)
![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?logo=amazonaws)
![Ubuntu](https://img.shields.io/badge/Ubuntu-24.04-E95420?logo=ubuntu)
![Nginx](https://img.shields.io/badge/Nginx-Web%20Server-009639?logo=nginx)

A hands-on **Infrastructure as Code (IaC)** project using **Terraform and AWS** to provision a complete public cloud environment from scratch.

The project demonstrates AWS networking, EC2 provisioning, security controls, Terraform variables and outputs, SSH access, Nginx deployment, infrastructure verification, and Git/GitHub workflow.

---

## 📌 Project Overview

This project provisions an AWS environment using Terraform:

- Custom VPC
- Public subnet
- Internet Gateway
- Public route table
- Internet route
- Route table association
- Security Group
- Ubuntu EC2 instance
- Dynamic Ubuntu AMI lookup
- Terraform variables
- Terraform outputs
- SSH access
- Nginx web server

The infrastructure was deployed in the AWS `ap-south-1` region.

---

# 🏗️ Architecture

```text
                         INTERNET
                            │
                            │
                            ▼
                  ┌──────────────────┐
                  │ Internet Gateway │
                  └────────┬─────────┘
                           │
                           │ 0.0.0.0/0
                           ▼
                ┌───────────────────────┐
                │         VPC           │
                │      10.0.0.0/16      │
                │                       │
                │  ┌─────────────────┐  │
                │  │  Public Subnet  │  │
                │  │   10.0.1.0/24   │  │
                │  │                 │  │
                │  │  ┌───────────┐  │  │
                │  │  │    EC2    │  │  │
                │  │  │  Ubuntu   │  │  │
                │  │  │  10.0.1.11│  │  │
                │  │  └─────┬─────┘  │  │
                │  │        │         │  │
                │  │        ▼         │  │
                │  │      Nginx       │  │
                │  │       :80        │  │
                │  └─────────────────┘  │
                └───────────────────────┘

```

---

## Traffic Flow

```
Internet
   │
   ▼
Public IP
   │
   ▼
Internet Gateway
   │
   ▼
Public Route Table
   │
   ▼
Public Subnet
   │
   ▼
Security Group
   │
   ▼
EC2
   │
   ▼
Nginx :80
```

---

## ☁️ AWS Resources

Terraform creates and manages the following resources:

```
| Resource                | Purpose                                |
| ----------------------- | -------------------------------------- |
| VPC                     | Isolated AWS network                   |
| Public Subnet           | Hosts the EC2 instance                 |
| Internet Gateway        | Internet connectivity                  |
| Route Table             | Controls network routing               |
| Route                   | Sends internet traffic through the IGW |
| Route Table Association | Associates subnet with route table     |
| Security Group          | Controls inbound/outbound traffic      |
| EC2                     | Cloud compute instance                 |
| Ubuntu AMI              | Operating system image                 |
```

---

## 🔐 Security Group

The EC2 Security Group contains:

```
| Protocol | Port | Source                        | Purpose  |
| -------- | ---: | ----------------------------- | -------- |
| TCP      |   22 | Administrator public IP `/32` | SSH      |
| TCP      |   80 | `0.0.0.0/0`                   | HTTP     |
| All      |  All | `0.0.0.0/0`                   | Outbound |
```

SSH is restricted to the administrator's public IP instead of exposing port 22 to the entire Internet.

Example:

```
SSH
TCP 22
49.x.x.x/32
```
The actual administrator IP is intentionally not stored in this public repository.

---

## 🛠️ Technologies Used
Cloud
- AWS
- Amazon EC2
- Amazon VPC
- Subnets
- Internet Gateway
- Route Tables
- Security Groups

Infrastructure as Code
- Terraform

Operating System
- Ubuntu 24.04 LTS

Web Server
- Nginx

Networking
- IPv4
- CIDR
- Routing
- Public Subnets
- Internet Gateway
- Security Groups

DevOps Tools
- Git
- GitHub
- AWS CLI
- SSH

---

## 📁 Project Structure

```
terraform-aws-sre-lab/
│
├── main.tf
├── variables.tf
├── .gitignore
├── .terraform.lock.hcl
└── README.md
```
main.tf

Contains the AWS provider, networking resources, EC2 instance, security group, and Terraform outputs.

variables.tf

Contains configurable Terraform variables.

.terraform.lock.hcl

Locks the Terraform provider version information.

.gitignore

Prevents Terraform state, local provider files, and environment-specific variables from being committed.

---

## 🚀 Terraform Workflow

The infrastructure was created using the standard Terraform workflow:
```
terraform init
```
Initialize the Terraform working directory and download required providers.

```
terraform fmt
```
Format Terraform configuration files.

```
terraform validate
```
Validate the Terraform configuration.

```
terraform plan
```
Preview infrastructure changes before applying them.

```
terraform apply
```
Create or update the infrastructure.

```
terraform output
```
Display important infrastructure information.

---

## ⚙️ Terraform Configuration
Provider

AWS is configured for the Mumbai region:

```
provider "aws" {
  region = var.aws_region
}
```
The region is configurable through Terraform variables.

---

## 🌐 VPC

The project creates a custom VPC:

```
CIDR: 10.0.0.0/16
```
The VPC has DNS support and DNS hostnames enabled.

---

## 📡 Public Subnet

A public subnet is created:

```
CIDR: 10.0.1.0/24
Availability Zone: ap-south-1a
```
Instances launched in the subnet can receive public IPv4 addresses.


---

## 🌍 Internet Gateway

An Internet Gateway is attached to the VPC.

It provides the path between the VPC and the public Internet.


---

## 🛣️ Route Table

The public route table contains:

```
Destination: 0.0.0.0/0
Target: Internet Gateway
```

This allows Internet-bound traffic from the public subnet to reach the Internet Gateway.


---

## 🔒 Security Group

The EC2 instance is protected using an AWS Security Group.

SSH access:

```
TCP 22 → Administrator IP
```
HTTP access:

```
TCP 80 → 0.0.0.0/0
```
Outbound traffic is allowed for the lab environment.

---

## 🖥️ EC2 Instance

Terraform dynamically discovers the latest matching Ubuntu 24.04 AMI instead of hardcoding an AMI ID.

Example configuration:

```
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}
```
The EC2 instance is deployed into the Terraform-managed public subnet.

---

## 🔑 SSH Access

The EC2 instance uses the existing AWS key pair:

sre-demo

Example:

```
ssh -i ~/sre-demo.pem ubuntu@<EC2_PUBLIC_IP>
```
Successful SSH access verified that:

```
Internet
   ↓
AWS Public IP
   ↓
Internet Gateway
   ↓
Route Table
   ↓
Public Subnet
   ↓
Security Group
   ↓
EC2
```
was functioning correctly.

---

## 🌐 Nginx Deployment

Nginx was installed on the EC2 instance:

```
sudo apt update
sudo apt install nginx -y
```
Service status was verified with:

```
sudo systemctl status nginx
```
Expected:

```
Active: active (running)
```

---

## 🧪 Infrastructure Verification

The infrastructure was tested from multiple layers.

1. Terraform Verification
```
terraform plan
```
Result:

```
No changes. Your infrastructure matches the configuration.
```
This confirmed that Terraform state and the actual AWS infrastructure were synchronized.

2. SSH Verification
```
ssh -i ~/sre-demo.pem ubuntu@<EC2_PUBLIC_IP>
```
SSH access succeeded.

3. EC2 Network Verification

Inside the EC2 instance:

```
ip addr
```
The instance received:

```
10.0.1.11/24
```
4. Internet Connectivity

Inside EC2:

```
curl -4 ifconfig.me
```
The EC2 instance successfully reached the public Internet.

5. Nginx Local Verification

Inside EC2:

```
curl http://localhost
```
The Nginx welcome page was returned successfully.

6. External HTTP Verification

From the local machine:

```
curl http://<EC2_PUBLIC_IP>
```
The Nginx welcome page was successfully returned.

This confirmed end-to-end connectivity:

```
Local Machine
     │
     ▼
Internet
     │
     ▼
EC2 Public IP
     │
     ▼
Security Group :80
     │
     ▼
Nginx
```

---

## 📤 Terraform Outputs

The project exposes important infrastructure information using Terraform outputs.

Run:

```
terraform output
```
Example:

```
instance_id = "i-xxxxxxxxxxxxxxxxx"
private_ip  = "10.0.1.11"
public_ip   = "xx.xx.xx.xx"
```
This avoids manually querying AWS for commonly needed values.


---

## 🔧 Terraform Variables

Environment-specific values are separated from the Terraform resource definitions.

Example terraform.tfvars:

```
aws_region    = "ap-south-1"
instance_type = "t2.nano"
```
The variable definitions are stored in:

```
variables.tf
```
Environment-specific .tfvars files are intentionally excluded from Git.

---

## 🧠 Terraform Concepts Learned

This project was built to practice real Terraform concepts rather than only copying a template.

Resources

Terraform resources represent infrastructure that Terraform manages.

Example:

```
resource "aws_instance" "web" {
  ...
}
```

Data Sources

Data sources allow Terraform to retrieve existing information from AWS.

Example:

```
data "aws_ami" "ubuntu" {
  ...
}
```

Variables

Variables make infrastructure configuration reusable.

```
variable "aws_region" {
  type = string
}
```

Outputs

Outputs expose useful infrastructure information:

```
output "public_ip" {
  value = aws_instance.web.public_ip
}
```
Terraform State

Terraform maintains a state file to track infrastructure that it manages.

The state allows Terraform to compare:

```
Desired Configuration
        │
        ▼
Terraform State
        │
        ▼
Actual AWS Infrastructure
```
and determine whether changes are required.

---

Terraform Plan

terraform plan was used throughout the project before applying changes.

Examples:

```
Plan: 7 to add, 0 to change, 0 to destroy.
```
and after deployment:

```
No changes. Your infrastructure matches the configuration.
```

---

## 🔐 Security Considerations

The project follows several basic security practices:


- SSH is restricted to a specific public IP.
- SSH is not exposed to 0.0.0.0/0.
- Terraform state is excluded from Git.
- Terraform variable files are excluded from Git.
- AWS credentials are not stored in Terraform files.
- Existing AWS key pairs are referenced rather than committing private keys.
- The EC2 instance is deployed into a custom VPC and subnet.
- HTTP is exposed only because this is a public web-server lab.

For production environments, additional controls would be required, such as:

- AWS IAM least privilege
- SSM Session Manager instead of public SSH
- Private subnets
- Load balancers
- HTTPS/TLS
- AWS WAF
- CloudWatch monitoring
- Centralized logging
- Remote Terraform state
- State locking
- Secrets management
- Multiple Availability Zones

---

## 💰 Cost Considerations

This is a learning environment and AWS resources may incur charges depending on account eligibility, region, resource type, and current AWS pricing.

Before finishing the lab, destroy resources that are no longer required:

```
terraform destroy
```
Review the destruction plan carefully before confirming.

Do not leave unnecessary EC2 instances, NAT Gateways, public IPv4 addresses, or other billable resources running.

---

## 🧹 Cleanup

To remove the Terraform-managed infrastructure:

```
terraform destroy
```
Terraform will show the resources that will be destroyed.

Only confirm after reviewing the plan:

```
Do you want to perform these actions?
Only 'yes' will be accepted to approve.
```
Enter:

```
yes
```
After cleanup:

```
terraform plan
```
should show that Terraform wants no resources remaining if the configuration has also been adjusted accordingly, or otherwise may propose recreating the resources declared in main.tf.

---

## 📊 Skills Demonstrated

AWS
- EC2
- VPC
- Subnets
- Internet Gateway
- Route Tables
- Security Groups
- AMI selection
- Public IPv4 networking

Terraform
- Provider configuration
- Resources
- Data sources
- Variables
- Variable files
- Outputs
- State
- Dependency management
- Plan
- Apply
- Destroy
- Infrastructure verification

Linux
- Ubuntu
- SSH
- systemd
- Nginx
- Network troubleshooting
- Package management

Networking
- CIDR
- IPv4
- Public subnets
- Default routes
- Internet Gateway
- Security group rules
- Public/private IP addressing

DevOps
- Infrastructure as Code
- Git
- GitHub
- AWS CLI
- Infrastructure automation
- Deployment verification
- Basic security practices

---

## 🎯 Project Goals

The main goal of this project was to move from manually creating AWS infrastructure through the AWS Console toward reproducible Infrastructure as Code.

Instead of manually creating:

```
VPC
Subnet
Route Table
Internet Gateway
Security Group
EC2
```
the infrastructure can be defined in Terraform and recreated consistently.

---

## 🚀 Future Improvements

Possible next improvements include:

- Remote Terraform state using Amazon S3
- State locking / locking strategy
- Terraform modules
- Separate development and production environments
- Private subnet architecture
- Application Load Balancer
- Auto Scaling Group
- IAM roles for EC2
- AWS Systems Manager Session Manager
- CloudWatch monitoring
- Terraform CI/CD using GitHub Actions
- Security scanning with Checkov or tfsec
- Automated Nginx installation using EC2 user data
- Ansible configuration management
- HTTPS with ACM
- Multi-AZ architecture

---

## 📚 Learning Outcome

This project provided hands-on experience with the complete Infrastructure as Code lifecycle:

```
Write Terraform
      ↓
terraform fmt
      ↓
terraform validate
      ↓
terraform plan
      ↓
terraform apply
      ↓
AWS Infrastructure
      ↓
SSH / HTTP Testing
      ↓
terraform plan
      ↓
Infrastructure Verification
```
The project demonstrates the ability to provision, inspect, test, and manage AWS infrastructure using Terraform.

