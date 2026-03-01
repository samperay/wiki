# Interview Questions

https://cloudchamp.notion.site/Terraform-Scenario-based-Interview-Questions-bce29cb359b243b4a1ab3191418bfaab

You can create 3-tier architecture using the below codebase
https://github.com/ajitinamdar-tech/three-tier-arch-aws-terraform


- How do you define tags which are common to all the resources which you create 

```h
variable "common_tags" {
  type = map(string)
  default = {
    Owner       = "sunil"
    Project     = "core-infra"
    ManagedBy   = "terraform"
    CostCenter  = "cc-123"
  }
}
# 
locals {
  tags = merge(var.common_tags, 
        { Environment = var.env }
  )
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags       = merge(local.tags, { Name = "main-vpc" })
}

output "debug_tags" {
  value = local.tags
}

```


- How do you reference the list using terraform variable defined ?

```h
variable "subnet_ids" {
  type = list(string)
  default = ["subnet-1"]
}

# index
subnet_id = var.subnet_ids[0]

# loop
resource "aws_network_interface" "eni" {
  count     = length(var.subnet_ids)
  subnet_id = var.subnet_ids[count.index]
}
```

- How to create 3 instances of the ec2 instance at once ?

```h
resource "aws_instance" "web" {
  count         = 3
  ami           = "ami-xxx"
  instance_type = "t2.micro"
  tags          = { Name = "web-${count.index}" }
}

output "instances" {
  value = aws_instance.web.*
}

```


- Required to create 1 instance of t2.micro and t3.xlarge based on the dev / prod environment ?

```h
variable "env" { type = string }

locals {
  instance_type = var.env == "prod" ? "t3.xlarge" : "t2.micro"
}

resource "aws_instance" "app" {
  ami           = var.ami_id
  instance_type = local.instance_type
  subnet_id     = var.subnet_id
}

output "env_instance" {
  value = aws_instance.app.*
}
```


- What do you do when you want to see the logs in details when you need to debug the terraform code ?

```h
export TF_LOG=DEBUG  # TRACE, DEBUG, INFO, WARN, ERROR
export TF_LOG_PATH=./tf.log
terraform apply
```

- You have alredy defined the VPC Tags, based on the tags we need to create an public instance in the - defined subnet? How to achieve this ?

Terraform can’t “query AWS by tags” natively unless you use a data source

```h
data "aws_subnets" "public" {
  filter {
    name   = "tag:Tier"
    values = ["public"]
  }
  filter {
    name   = "vpc-id"
    values = [aws_vpc.main.id]
  }
}

resource "aws_instance" "public_ec2" {
  ami                         = var.ami_id
  instance_type               = "t2.micro"
  subnet_id                   = data.aws_subnets.public.ids[0]
  associate_public_ip_address = true
}
```

- How do I define the list of all the ports at once and add all of them using the resource group?

```h
variable "allowed_ports" {
  type    = list(number)
  default = [22, 80, 443, 8080]
}

resource "aws_security_group" "web_sg" {
  name   = "web-sg"
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.allowed_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

- What are the provisioners available in terraform and can you illustrate each of them as when and where - to be used ?

**local-exec:** runs on your machine (CI runner)

```h
provisioner "local-exec" {
  command = "echo ${self.public_ip} >> ips.txt"
}
```

**remote-exec:** runs on the created resource (via SSH/WinRM)

```h
provisioner "remote-exec" {
  inline = ["sudo yum install -y nginx", "sudo systemctl enable --now nginx"]

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.ssh_key_path)
    host        = self.public_ip
  }
}
```


**file:** copies files to the remote instance

```h
provisioner "file" {
  source      = "app.conf"
  destination = "/tmp/app.conf"
  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.ssh_key_path)
    host        = self.public_ip
  }
}
```

- How do you define modules and how do you reference in terraform ?

A module is just a folder with main.tf, variables.tf, outputs.tf.

```h
module "vpc" {
  source = "./modules/vpc" 
  cidr   = "10.0.0.0/16"
  tags   = local.tags
}

output "vpc_id" {
  value = module.vpc.vpc_id
}
```

- How do you use the modulues which are already created by Hashicorp and use in the terraform script ?

```h
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "main"
  cidr = "10.0.0.0/16"
  azs  = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.101.0/24", "10.0.102.0/24"]

  tags = local.tags
}
```

- What are workspaces and how do you create environment using the workspaces ?

Workspaces let you keep separate state files for same code

```
terraform workspace new dev
terraform workspace new prod
terraform workspace select dev
```

```h
locals {
  env = terraform.workspace
}

resource "aws_instance" "app" {
  instance_type = local.env == "prod" ? "t3.xlarge" : "t2.micro"
}
```


- What is remote state management and how do you use it ?

Store state in a shared backend (S3 + DynamoDB lock is common).

```h
terraform {
  backend "s3" {
    bucket         = "my-tf-state-bucket"
    key            = "envs/dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "my-tf-locks"
    encrypt        = true
  }
}
```

- How do you create multiple resources in different regions using multiple providers ?

```h
provider "aws" {
  region = "us-east-1"
}

provider "aws" {
  alias  = "west"
  region = "us-west-2"
}

resource "aws_s3_bucket" "east" {
  bucket = "sunil-east-bkt"
}

resource "aws_s3_bucket" "west" {
  provider = aws.west
  bucket   = "sunil-west-bkt"
}
```

- How do you enusure your password are kept secret using the terraform ?

```h
variable "db_password" {
  type      = string
  sensitive = true
}

resource "aws_db_instance" "rds" {
  password = var.db_password
}
```

- How do you set the terraform to be in-specific versions in the code and what happens if its not been set ?

```h
terraform {
  required_version = "~> 1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
```

- what happens when you do "terraform init" ?
1. Downloads providers
2. Initializes backend (remote state)
3. Downloads modules
4. Creates .terraform/ and lock file terraform.lock.hcl

- what is the difference between "terraform plan" and "terraform refresh" ?

terraform plan: computes changes needed to match config with real infra.

terraform refresh (legacy): updates state from real resources (doesn’t change infra).

Modern approach: terraform apply -refresh-only.

- I do need to destroy certain resources in the terraform, how do I do it in particular ?

```h
terraform destroy -target=aws_instance.web[0]
terraform destroy -target=module.vpc
```

- I do already have a terraform instance running, however I have lost the terraform file, Can I re-create - the terraform state file ?

If you used remote backend, state is already there (good).

If you lost local state and code:

You cannot reliably reconstruct full original config from state alone.

You can:

Pull state (if backend exists): terraform state pull

Rebuild minimal config and then terraform import resources

Use tools like Terraformer (best-effort), but imports still required.

If you still have resources in AWS but no state:

Create new project → terraform import each resource into new state.


- What is the difference between "variable.tf" and "terraform.tfvars" ?

variables.tf: declares variables (type, description, defaults)

terraform.tfvars: assigns values to variables (per environment)

```h
# variables.tf
variable "env" { type = string }

# terraform.tfvars
env = "dev"
```

- I would required to create an RDS instance before by AWS instance, How do I do it ?

Terraform builds a dependency graph automatically.
To force order:

**Reference RDS outputs in EC2 (best)**

```h
resource "aws_db_instance" "rds" { ... }

resource "aws_instance" "app" {
  # example: pass RDS endpoint to user_data
  user_data = templatefile("${path.module}/user_data.sh", {
  db_host = aws_db_instance.rds.address
  })
}
```

Or depends_on (explicit)

```h
resource "aws_instance" "app" {
  depends_on = [aws_db_instance.rds]
  ...
}
```

- I have certain resources created using terraform and how do I keep this file in consistent so that it won't be corrupted or so?

Use remote backend with locking (S3 + DynamoDB)

Commit terraform.lock.hcl

Pin Terraform + provider versions

Run in CI: terraform fmt, validate, plan

Avoid manual changes in cloud (or use refresh-only + import)

Protect state bucket (versioning + encryption + restricted IAM)

Separate environments (workspaces or separate backends)
