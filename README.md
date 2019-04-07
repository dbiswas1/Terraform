# Setup Kubernetes Cluster with Terraform and Kops - PART 1

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

#### Install Terraform

