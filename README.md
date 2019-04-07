# Setup Kubernetes Cluster with Terraform and Kops - PART 1
  * [Who should read this Blog:](#who-should-read-this-blog-)
  * [Short introduction](#short-introduction)
      - [What is Terraform?](#what-is-terraform-)
      - [What is Kubernetes ?](#what-is-kubernetes--)
  * [Problem we are trying to solve](#problem-we-are-trying-to-solve)
  * [Stack used](#stack-used)
  * [Actual implementation](#actual-implementation)
      - [Install Terraform, Kops and Kubectl](#install-terraform--kops-and-kubectl)
      - [Setup S3, VPC and Domain using Terraform](#setup-s3--vpc-and-domain-using-terraform)
      - [Setup K8 Cluster using KOPS](#setup-k8-cluster-using-kops)
      - [Install a Smaple Application in the K8 Cluster](#install-a-smaple-application-in-the-k8-cluster)
      - [Cleanup the setup](#cleanup-the-setup)
## Who should read this Blog:
This Blog is for those who wants to quickly get an overall general understanding on setting up a container eco system 
and understand how **infrastructure as a code** looks like. this is meant for all who wants to see an working example 
of the above mentioned concepts.

This is not an advanced level tutorial. 
1) I am using **Terraform** to maintain the underlying Infrastructure which will 
the host the set of containers/pods
2) I am using **Kubernetes (K8)** as container Orchestrator
3) Using **Kops** to manage the K8 Cluster lifecycle
4) Using **AWS** as cloud provider

## Short introduction
The aim of this blog is not to give in depth knowledge of Terraform or K8. but to show an working example as a quick 
start guide
#### What is Terraform?
Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage 
existing and popular service providers as well as custom in-house solutions.

Pls refer : https://www.terraform.io/intro/index.html for further info

#### What is Kubernetes ?
K8  is an open-source system for automating deployment, scaling, and management of containerized applications. It 
groups containers that make up an application into logical units for easy management and discovery.

Pls refer : https://kubernetes.io/ for further info

## Problem we are trying to solve
We will launch an AWS VPC, S3 bucket and Domain using terraform which are AWS resources and use KOPS for launcing the ec2
instances of master and nodes to set up a K8 Cluster

## Stack used
Cloud: AWS
Region: us-west-2
Instance Type: t2.medium
OS: Ubuntu 18.04
AMI : ami-005bdb005fb00e791

Note: Please check the details before using scripts to launch it will incur some cost in the AWS 

## Actual implementation

#### Install Terraform, Kops and Kubectl
clone the repo https://github.com/dbiswas1/Terraform.git

```
git clone https://github.com/dbiswas1/Terraform.git
cd Terraform
chmod 755 setup_env.sh
./setup_env.sh

###############################################
#Output will be as follows
###############################################

Hit:1 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic InRelease
Get:2 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-updates InRelease [88.7 kB]
Get:3 http://us-west-2.ec2.archive.ubuntu.com/ubuntu bionic-backports InRelease [74.6 kB]
Get:4 http://security.ubuntu.com/ubuntu bionic-security InRelease [88.7 kB]
Fetched 252 kB in 1s (298 kB/s)
Reading package lists... Done
Reading package lists... Done
Building dependency tree
Reading state information... Done
jq is already the newest version (1.5+dfsg-2).
0 upgraded, 0 newly installed, 0 to remove and 73 not upgraded.
Reading package lists... Done
Building dependency tree
Reading state information... Done
unzip is already the newest version (6.0-21ubuntu1).
0 upgraded, 0 newly installed, 0 to remove and 73 not upgraded.
======================================================================================
[2019-04-07 08:24:17]: INFO: Start Kops Download -> Version : 1.11.1 and Flavor: kops-linux-amd64
[2019-04-07 08:24:23]: INFO: Download Complete
[2019-04-07 08:24:23]: INFO: Kops setup done -> Version : 1.11.1 and Flavor: kops-linux-amd64
======================================================================================
[2019-04-07 08:24:23]: INFO: Start Kubectl Download
[2019-04-07 08:24:24]: INFO: Download Complete
[2019-04-07 08:24:24]: INFO: Kubectl setup done -> Version : v1.14.0
======================================================================================
[2019-04-07 08:24:26]: INFO: Download Terraform -> Version 0.11.13
[2019-04-07 08:24:27]: INFO: Download Complete
Archive:  terraform_0.11.13_linux_amd64.zip
  inflating: terraform
======================================================================================
[2019-04-07 08:24:29]: INFO: VERIFY KOPS
[2019-04-07 08:24:30]: INFO: VERIFY KUBECTL
[2019-04-07 08:24:30]: INFO: VERIFY TERRAFORM
Terraform v0.11.13

[2019-04-07 08:24:30]: INFO: Validation Successful !!!
======================================================================================
```

#### Setup S3, VPC and Domain using Terraform
**WIP**

#### Setup K8 Cluster using KOPS
**WIP**

#### Install a Smaple Application in the K8 Cluster
**WIP**

#### Cleanup the setup
**WIP**

