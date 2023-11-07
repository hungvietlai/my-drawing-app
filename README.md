# My-drawing-app with Terraform on AWS

This repository contains the source code and necessary configurations for my_drawing_app, a simple drawing application developed in Node.js, to be hosted on AWS using an EKS cluster.

---

## Table of Contents

- [Architecture](#architecture)
- [Prerequisites](#prerequisites)
- [Deployment](#deployment)
- [Cleanup](#cleanup)
- [License](#license)

---

## Architecture

```plaintext

MY-DRAWING-APP
│___Dockerfile
│___Jenkinsfile
│___package-lock.json
│___package.json
│___README.md
│___LICENSE
│___server.js
│
├───images
│   │___my_drawing_app.png
│
├───k8s-yaml-file
│   │___deployment.yaml
│   │___service.yaml
│
├───public
│   │___app.js
│   │___index.html
│   │___style.css
│
├───terraform
│   │___main.tf
│   │___output.tf
│   │___variables.tf
│   │
│   └───module
│       └───eks
│           │___main.tf
│           │___output.tf
│           │___variables.tf
│
└───test
    │___app.test.js
```

---

## Prerequisites

- Ensure you have the following tools installed:

- AWS CLI
- eksctl
- kubectl
- See the link below for guide on "Getting started with Amazon EKS" 

(https://docs.aws.amazon.com/eks/latest/userguide/getting-started.html)

- Once installed, verify your installations with:

```bash
aws --version
eksctl version
kubectl version
```

- You also need to configure 'aws' with your credentials:

```bash
aws configure
```
- This will prompt you to enter your AWS access key, secret key, region, and output format. You can find the relevant informations from your IAM service.

---

## Deployment

### 1. Creating EKS cluster

#### 1.1 Clone repository

```bash
git clone https://github.com/hungvietlai/my-drawing-app.git
cd terraform/
```

#### 1.2 Configure your VPC 

```bash

resource "aws_vpc" "<vpc_name>" {
  # The CIDR block for the VPC.
  cidr_block = "<my_cidr_block>"

  # Required for EKS. Enable/disable DNS support in the VPC.
  enable_dns_support = true

  # Required for EKS. Enable/disable DNS hostnames in the VPC.
  enable_dns_hostnames = true

  # A map of tags to assign to the resource.
  tags = {
    Name = "<my_tag>"
  }
}

```
- **Note**: ensure to change all the vpc_id with aws_vpc.<vpc_name>.id

#### 1.3 Set up your cluster's name

```bash
resource "aws_eks_cluster" "my_cluster" {
  name     = "<cluster_name>"

}
```

- **Note**: ensure to change the tag from the subnet as well

```bash
tags = {
    Name                                           = "my_public_subnet2"
    "kubernetes.io/cluster/<cluster_name>"         = "shared"
    "kubernetes.io/role/elb"                       = 1
  }

```

#### 1.4 Deploy EkS cluster

```bash
terraform apply
```


### 2. Configure kubectl

- This will update your kubectl so it will know which cluster to manage.

```bash
aws eks --region <region_code> update-kubeconfig --name <cluster_name>
```

#### 2.1 Verify your nodes:

```bash
kubectl get nodes
```
- There should be 3 nodes.

### 3.Deploy the Voting App:

```bash

cd k8s-yaml-files/
for file in *.yaml; do kubectl create -f $file; done
```
#### 3.1 Check deployments, services:

```bash
kubectl get deploy,svc
```
- You should observe 2 deployments and 2 services.

### 4. Access the app:

- Access the drawing app via LoadBalancer public IP

- **Note**: If you can't access the app, review the security settings of the LB in the EC2 dashboard. Ensure inbound rules allow traffic on ports 80.

## Clean Up:

- When done testing, to avoid unnecessary costs, delete the cluster:

```bash
kubectl delete deploy <deployment_name>
kubectl delete svc <service_name>
terraform destroy
```
## Licensing 

This project is licensed under the MIT License. For the full text of the license, see the LICENSE file.

![drawing-app-image](https://github.com/hungvietlai/my-drawing-app/blob/main/images/my_drawing_app.png)