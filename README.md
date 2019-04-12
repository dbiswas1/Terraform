# Setup Kubernetes Cluster with Terraform and Kops - PART 1
  * [Who should read this Blog:](#who-should-read-this-blog)
  * [Short introduction](#short-introduction)
      - [What is Terraform](#what-is-terraform)
      - [What is Kubernetes](#what-is-kubernetes)
      - [What is KOPS](#What-is-KOPS)
      - [What is Kubect](#What is Kubectl)
  * [Problem we are trying to solve](#problem-we-are-trying-to-solve)
  * [Stack used](#stack-used)
  * [Actual implementation](#actual-implementation)
      - [Install Terraform, Kops and Kubectl](#install-terraform-kops-and-kubectl)
      - [Setup S3, VPC and Domain using Terraform](#setup-s3-vpc-and-domain-using-terraform)
      - [Setup K8 Cluster using KOPS](#setup-k8-cluster-using-kops)
      - [Validate the K8 Setup](#Validate-the-K8-Setup)
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
#### What is Terraform
Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage 
existing and popular service providers as well as custom in-house solutions.

Pls refer : https://www.terraform.io/intro/index.html for further info

#### What is Kubernetes
K8  is an open-source system for automating deployment, scaling, and management of containerized applications. It 
groups containers that make up an application into logical units for easy management and discovery.

Pls refer : https://kubernetes.io/ for further info

#### What is KOPS
kops helps you create, destroy, upgrade and maintain production-grade, highly available, Kubernetes clusters from the 
command line. AWS (Amazon Web Services) is currently officially supported

Pls refer: https://github.com/kubernetes/kops

#### What is Kubectl
Kubectl is a command line interface for running commands against Kubernetes clusters

Pls refer: https://kubernetes.io/docs/reference/kubectl/overview/

## Problem we are trying to solve
We will launch an AWS VPC, S3 bucket and Domain using terraform which are AWS resources and use KOPS for launcing the ec2
instances of master and nodes to set up a K8 Cluster

## Stack used
* Cloud: `AWS`
* Region: `us-west-2`
* Instance Type: `t2.medium`
* OS: Ubuntu `18.04`
* AMI : `ami-005bdb005fb00e791`

Note: Please check the details before using scripts to launch it will incur some cost in the AWS 

## Actual implementation

#### Install Terraform, Kops and Kubectl
clone the repo https://github.com/dbiswas1/Terraform.git

```
git clone https://github.com/dbiswas1/terraform.git
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

#### Setup S3, VPC and Security Group using Terraform
* clone the repo `git clone https://github.com/dbiswas1/terraform.git`
* cd terraform-files
* `terraform init` to initialise the terraform workspace
* `terraform plan` this is a dry run where actual exceution doesnot happen but terraform shows what it will do
* `terraform graph` optional but you can check how the dependencies are
* finally `terraform apply` to execute
* giving some sample output below you would also see how terraform outputs file is helping displaying the required output
* in this terraform files we have covered how to use 
   * [data](https://www.terraform.io/docs/configuration/data-sources.html)
   * [modules](https://www.terraform.io/docs/modules/index.html)
   * [outputs](https://www.terraform.io/docs/configuration/outputs.html)
   * [local variables](https://www.terraform.io/docs/configuration/locals.html) .. we will cover more in subsequent series
* Some references 
    * https://github.com/terraform-aws-modules/terraform-aws-vpc
    
```
#########################################################################
# Output of a terraform plan
#########################################################################
ubuntu@ip-172-31-44-201:~/terraform/terraform-files$ terraform init
Initializing modules...
- module.blog_vpc
  Found version 1.60.0 of terraform-aws-modules/vpc/aws on registry.terraform.io
  Getting source "terraform-aws-modules/vpc/aws"

Initializing provider plugins...
- Checking for available provider plugins on https://releases.hashicorp.com...
- Downloading plugin for provider "aws" (2.6.0)...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.aws: version = "~> 2.6"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```
```
######################################################################
# output of a terraform apply 
#######################################################################
module.blog_vpc.aws_route.private_nat_gateway[1]: Creation complete after 0s (ID: r-rtb-093a778094db492241080289494)
module.blog_vpc.aws_route.private_nat_gateway[2]: Creation complete after 0s (ID: r-rtb-020cf78f454e1aba71080289494)
module.blog_vpc.aws_route.private_nat_gateway[0]: Creation complete after 0s (ID: r-rtb-0e006178f8bfa887a1080289494)

Apply complete! Resources: 9 added, 0 changed, 0 destroyed.

Outputs:

availability_zones = [
    us-west-2a,
    us-west-2b,
    us-west-2c
]
common_http_sg_id = sg-04bb26488f455e9a5
default_security_group_id = sg-020a829bcdc36d239
kops_s3_bucket = k8.cloudservices2go.com
kubernetes_cluster_name = blog.cloudservices2go.com
nat_gateway_ids = [
    nat-04884a9df64dc2099,
    nat-0ccbf831effb9ad2c,
    nat-05ffe724a00e92a26
]
private_route_table_ids = [
    rtb-0e006178f8bfa887a,
    rtb-093a778094db49224,
    rtb-020cf78f454e1aba7
]
private_subnet_ids = [
    subnet-03788eca5f2aa0f69,
    subnet-08f88757683c4e6d5,
    subnet-0d0508d513a0db975
]
public_route_table_ids = [
    rtb-0135b9019663b2909
]
public_subnet_ids = [
    subnet-0d605eda93449e46a,
    subnet-018aeef0867af06fb,
    subnet-0fcb2eb7dd8289fc5
]
region = us-west-2
vpc_cidr_block = 14.0.0.0/16
vpc_id = vpc-06a1a64382adb8ed4
vpc_name = blog-vpc-cloudservices2go.com

```

#### Setup K8 Cluster using KOPS and Terraform
* we will make use of [`kops templating`](https://github.com/kubernetes/kops/blob/master/docs/cluster_template.md) tool which is based on `GO` templates 
* we will make sure we have ~/.ssh/id-rsa.pub ready else generate one using `ssh-keygen`
* run `kops create secret --name blog.cloudservices2go.com --state s3://k8.cloudservices2go.com sshpublickey admin -i ~/.ssh/id_rsa.pub`
    * the above steps is due to kops issue Refer: https://github.com/kubernetes/kops/issues/3693
* we now run a small utility script `./generate-tf-files.sh` from the repo to generate the terraform files lets
* run `terraform init`
* run `terraform plan`
* run `terraform apply`
* BOOM ! our Kops cluster is ready

```
ubuntu@ip-172-31-44-201:~/terraform/k8$ kops create secret --name blog.cloudservices2go.com --state s3://k8.cloudservices2go.com sshpublickey admin -i ~/.ssh/id_rsa.pub
############################################################
# output of ./generate-tf-files.sh
############################################################
ubuntu@ip-172-31-44-201:~/terraform/k8$ ./generate-tf-files.sh

*********************************************************************************

A new kubernetes version is available: 1.10.13
Upgrading is recommended (try kops upgrade cluster)

More information: https://github.com/kubernetes/kops/blob/master/permalinks/upgrade_k8s.md#1.10.13

*********************************************************************************


*********************************************************************************

Kubelet anonymousAuth is currently turned on. This allows RBAC escalation and remote code execution possibilites.
It is highly recommended you turn it off by setting 'spec.kubelet.anonymousAuth' to 'false' via 'kops edit cluster'

See https://github.com/kubernetes/kops/blob/master/docs/security.md#kubelet-api

*********************************************************************************

W0412 11:21:08.616407    4709 external_access.go:39] KubernetesAPIAccess is empty
W0412 11:21:08.616444    4709 external_access.go:43] SSHAccess is empty
I0412 11:21:09.017197    4709 executor.go:103] Tasks: 0 done / 92 total; 40 can run
I0412 11:21:09.019234    4709 dnszone.go:242] Check for existing route53 zone to re-use with name ""
I0412 11:21:09.147644    4709 dnszone.go:249] Existing zone "cloudservices2go.com." found; will configure TF to reuse
I0412 11:21:09.370175    4709 vfs_castore.go:736] Issuing new certificate: "apiserver-aggregator-ca"
I0412 11:21:09.595899    4709 vfs_castore.go:736] Issuing new certificate: "ca"
I0412 11:21:09.807509    4709 executor.go:103] Tasks: 40 done / 92 total; 28 can run
I0412 11:21:10.623507    4709 vfs_castore.go:736] Issuing new certificate: "kube-controller-manager"
I0412 11:21:10.822131    4709 vfs_castore.go:736] Issuing new certificate: "kubecfg"
I0412 11:21:10.862803    4709 vfs_castore.go:736] Issuing new certificate: "kubelet"
I0412 11:21:10.903090    4709 vfs_castore.go:736] Issuing new certificate: "kube-scheduler"
I0412 11:21:11.101020    4709 vfs_castore.go:736] Issuing new certificate: "kubelet-api"
I0412 11:21:11.315278    4709 vfs_castore.go:736] Issuing new certificate: "master"
I0412 11:21:11.491097    4709 vfs_castore.go:736] Issuing new certificate: "apiserver-aggregator"
I0412 11:21:11.662531    4709 vfs_castore.go:736] Issuing new certificate: "kops"
I0412 11:21:11.704351    4709 vfs_castore.go:736] Issuing new certificate: "kube-proxy"
I0412 11:21:11.842441    4709 vfs_castore.go:736] Issuing new certificate: "apiserver-proxy-client"
I0412 11:21:12.070497    4709 executor.go:103] Tasks: 68 done / 92 total; 16 can run
I0412 11:21:12.195891    4709 executor.go:103] Tasks: 84 done / 92 total; 5 can run
I0412 11:21:12.196354    4709 executor.go:103] Tasks: 89 done / 92 total; 3 can run
I0412 11:21:12.196544    4709 executor.go:103] Tasks: 92 done / 92 total; 0 can run
I0412 11:21:12.203555    4709 target.go:312] Terraform output is in .
I0412 11:21:12.589124    4709 update_cluster.go:290] Exporting kubecfg for cluster
kops has set your kubectl context to blog.cloudservices2go.com

Terraform output has been placed into .
Run these commands to apply the configuration:
   cd .
   terraform plan
   terraform apply

Suggestions:
 * validate cluster: kops validate cluster
 * list nodes: kubectl get nodes --show-labels
 * ssh to the master: ssh -i ~/.ssh/id_rsa admin@api.blog.cloudservices2go.com
 * the admin user is specific to Debian. If not using Debian please use the appropriate user based on your OS.
 * read about installing addons at: https://github.com/kubernetes/kops/blob/master/docs/addons.md.
``` 
```
############################################################
# output of terraform init
############################################################
ubuntu@ip-172-31-44-201:~/terraform/k8$ terraform init

Initializing provider plugins...
- Checking for available provider plugins on https://releases.hashicorp.com...
- Downloading plugin for provider "aws" (2.6.0)...

The following providers do not have any version constraints in configuration,
so the latest version was installed.

To prevent automatic upgrades to new major versions that may contain breaking
changes, it is recommended to add version = "..." constraints to the
corresponding provider blocks in configuration, with the constraint strings
suggested below.

* provider.aws: version = "~> 2.6"

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

```

```
############################################################
# Curtailed output of terraform apply
############################################################
Apply complete! Resources: 40 added, 0 changed, 0 destroyed.

Outputs:

cluster_name = blog.cloudservices2go.com
master_autoscaling_group_ids = [
    master-us-west-2a.masters.blog.cloudservices2go.com,
    master-us-west-2b.masters.blog.cloudservices2go.com,
    master-us-west-2c.masters.blog.cloudservices2go.com
]
master_security_group_ids = [
    sg-0231e7ca2592da25b
]
masters_role_arn = arn:aws:iam::303882392497:role/masters.blog.cloudservices2go.com
masters_role_name = masters.blog.cloudservices2go.com
node_autoscaling_group_ids = [
    nodes.blog.cloudservices2go.com
]
node_security_group_ids = [
    sg-0e0aaf96e98bd2d64
]
node_subnet_ids = [
    subnet-03788eca5f2aa0f69,
    subnet-08f88757683c4e6d5,
    subnet-0d0508d513a0db975
]
nodes_role_arn = arn:aws:iam::303882392497:role/nodes.blog.cloudservices2go.com
nodes_role_name = nodes.blog.cloudservices2go.com
region = us-west-2
subnet_ids = [
    subnet-018aeef0867af06fb,
    subnet-03788eca5f2aa0f69,
    subnet-08f88757683c4e6d5,
    subnet-0d0508d513a0db975,
    subnet-0d605eda93449e46a,
    subnet-0fcb2eb7dd8289fc5
]
subnet_us-west-2a_id = subnet-03788eca5f2aa0f69
subnet_us-west-2b_id = subnet-08f88757683c4e6d5
subnet_us-west-2c_id = subnet-0d0508d513a0db975
subnet_utility-us-west-2a_id = subnet-0d605eda93449e46a
subnet_utility-us-west-2b_id = subnet-018aeef0867af06fb
subnet_utility-us-west-2c_id = subnet-0fcb2eb7dd8289fc5
vpc_id = vpc-06a1a64382adb8ed4

```

#### Validate the K8 Setup
* kops validate cluster would show us the cluster state we created
* NOTE: Make sure you created proper Security group settings in your TF to make this command work

```
############################################################
# output of Validate Cluster
############################################################
ubuntu@ip-172-31-44-201:~/terraform/k8$ kops validate cluster --state s3://k8.cloudservices2go.com
Using cluster from kubectl context: blog.cloudservices2go.com

Validating cluster blog.cloudservices2go.com

INSTANCE GROUPS
NAME			ROLE	MACHINETYPE	MIN	MAX	SUBNETS
master-us-west-2a	Master	t2.medium	1	1	us-west-2a
master-us-west-2b	Master	t2.medium	1	1	us-west-2b
master-us-west-2c	Master	t2.medium	1	1	us-west-2c
nodes			Node	t2.small	1	2	us-west-2a,us-west-2b,us-west-2c

NODE STATUS
NAME						ROLE	READY
ip-14-0-1-106.us-west-2.compute.internal	master	True
ip-14-0-1-184.us-west-2.compute.internal	node	True
ip-14-0-2-97.us-west-2.compute.internal		master	True
ip-14-0-3-4.us-west-2.compute.internal		master	True

Your cluster blog.cloudservices2go.com is ready

```
#### Install a Sample Application in the K8 Cluster
This is just an example app we will explain in detail in comming series how to deploy a full fledge application in K8.
here we are just validating the setup as intention was to create a K* cluster using terraform
steps are:
* export CLUSTER_NAME=blog.cloudservices2go.com
* export STATE=s3://k8.cloudservices2go.com
* kops export kubecfg --name ${CLUSTER_NAME} --state ${STATE}
* kubectl config set-cluster ${CLUSTER_NAME} --server=https://api.${CLUSTER_NAME}
* kubectl run -i --tty busybox --image=busybox -- sh
```
############################################################
# output of Application 
############################################################
ubuntu@ip-172-31-44-201:~/terraform/k8$ export CLUSTER_NAME=blog.cloudservices2go.com
ubuntu@ip-172-31-44-201:~/terraform/k8$ export STATE=s3://k8.cloudservices2go.com
ubuntu@ip-172-31-44-201:~/terraform/k8$ kops export kubecfg --name ${CLUSTER_NAME} --state ${STATE}
kops has set your kubectl context to blog.cloudservices2go.com
ubuntu@ip-172-31-44-201:~/terraform/k8$ kubectl config set-cluster ${CLUSTER_NAME} --server=https://api.${CLUSTER_NAME}
Cluster "blog.cloudservices2go.com" set.
ubuntu@ip-172-31-44-201:~/terraform/k8$ kubectl get pods --all-namespaces
NAMESPACE     NAME                                                               READY   STATUS    RESTARTS   AGE
kube-system   canal-kxrwc                                                        3/3     Running   0          9m
kube-system   canal-l842v                                                        3/3     Running   0          11m
kube-system   canal-sws2n                                                        3/3     Running   0          9m
kube-system   canal-vbqkg                                                        3/3     Running   0          11m
kube-system   dns-controller-64c55c5f49-qhjfz                                    1/1     Running   0          11m
kube-system   etcd-server-events-ip-14-0-1-106.us-west-2.compute.internal        1/1     Running   0          11m
kube-system   etcd-server-events-ip-14-0-2-97.us-west-2.compute.internal         1/1     Running   0          9m
kube-system   etcd-server-events-ip-14-0-3-4.us-west-2.compute.internal          1/1     Running   0          10m
kube-system   etcd-server-ip-14-0-1-106.us-west-2.compute.internal               1/1     Running   2          10m
kube-system   etcd-server-ip-14-0-2-97.us-west-2.compute.internal                1/1     Running   4          9m
kube-system   etcd-server-ip-14-0-3-4.us-west-2.compute.internal                 1/1     Running   4          10m
kube-system   kube-apiserver-ip-14-0-1-106.us-west-2.compute.internal            1/1     Running   3          10m
kube-system   kube-apiserver-ip-14-0-2-97.us-west-2.compute.internal             1/1     Running   4          8m
kube-system   kube-apiserver-ip-14-0-3-4.us-west-2.compute.internal              1/1     Running   4          10m
kube-system   kube-controller-manager-ip-14-0-1-106.us-west-2.compute.internal   1/1     Running   0          10m
kube-system   kube-controller-manager-ip-14-0-2-97.us-west-2.compute.internal    1/1     Running   0          9m
kube-system   kube-controller-manager-ip-14-0-3-4.us-west-2.compute.internal     1/1     Running   0          11m
kube-system   kube-dns-5fbcb4d67b-9tthl                                          3/3     Running   0          9m
kube-system   kube-dns-5fbcb4d67b-k659l                                          3/3     Running   0          11m
kube-system   kube-dns-autoscaler-6874c546dd-cc8mr                               1/1     Running   0          11m
kube-system   kube-proxy-ip-14-0-1-106.us-west-2.compute.internal                1/1     Running   0          10m
kube-system   kube-proxy-ip-14-0-1-184.us-west-2.compute.internal                1/1     Running   0          9m
kube-system   kube-proxy-ip-14-0-2-97.us-west-2.compute.internal                 1/1     Running   0          9m
kube-system   kube-proxy-ip-14-0-3-4.us-west-2.compute.internal                  1/1     Running   0          10m
kube-system   kube-scheduler-ip-14-0-1-106.us-west-2.compute.internal            1/1     Running   0          10m
kube-system   kube-scheduler-ip-14-0-2-97.us-west-2.compute.internal             1/1     Running   0          9m
kube-system   kube-scheduler-ip-14-0-3-4.us-west-2.compute.internal              1/1     Running   0          10m
ubuntu@ip-172-31-44-201:~/terraform/k8$ kubectl run -i --tty busybox --image=busybox -- sh
kubectl run --generator=deployment/apps.v1 is DEPRECATED and will be removed in a future version. Use kubectl run --generator=run-pod/v1 or kubectl create instead.
If you don't see a command prompt, try pressing enter.
/ #
/ # hostname
busybox-5858cc4697-6ml5s
/ # Session ended, resume using 'kubectl attach busybox-5858cc4697-6ml5s -c busybox -i -t' command when the pod is running
ubuntu@ip-172-31-44-201:~/terraform/k8$
ubuntu@ip-172-31-44-201:~/terraform/k8$ kubectl get pods --all-namespaces | grep busybox
default       busybox-5858cc4697-6ml5s
```

#### Cleanup the setup
`terraform destroy` in respective dirtectories will cleanup everything you have setup

```
########################################################################################################################
# Curtailed output of dsetroy inside k8 directory This will cleanup KOPS resources
########################################################################################################################
aws_security_group.masters-blog-cloudservices2go-com: Destroying... (ID: sg-0231e7ca2592da25b)
aws_key_pair.kubernetes-blog-cloudservices2go-com-028c527b33f74ce529a8c3bf07ae8da1: Destroying... (ID: kubernetes.blog.cloudservices2go.com-02...7b:33:f7:4c:e5:29:a8:c3:bf:07:ae:8d:a1)
aws_iam_instance_profile.masters-blog-cloudservices2go-com: Destroying... (ID: masters.blog.cloudservices2go.com)
aws_key_pair.kubernetes-blog-cloudservices2go-com-028c527b33f74ce529a8c3bf07ae8da1: Destruction complete after 0s
aws_security_group.masters-blog-cloudservices2go-com: Destruction complete after 1s
aws_iam_instance_profile.masters-blog-cloudservices2go-com: Destruction complete after 1s
aws_iam_role.masters-blog-cloudservices2go-com: Destroying... (ID: masters.blog.cloudservices2go.com)
aws_iam_role.masters-blog-cloudservices2go-com: Destruction complete after 0s

Destroy complete! Resources: 40 destroyed.

```
```
########################################################################################################################
# Curtailed output of dsetroy inside terraform-files directory This will cleanup Networks, SG and S3
########################################################################################################################
module.blog_vpc.aws_eip.nat[0]: Destroying... (ID: eipalloc-0edf9c365bc69e954)
module.blog_vpc.aws_eip.nat[1]: Destruction complete after 0s
module.blog_vpc.aws_eip.nat[2]: Destruction complete after 0s
module.blog_vpc.aws_eip.nat[0]: Destruction complete after 0s
module.blog_vpc.aws_subnet.public[1]: Destruction complete after 1s
module.blog_vpc.aws_subnet.public[2]: Destruction complete after 1s
module.blog_vpc.aws_subnet.public[0]: Destruction complete after 1s
module.blog_vpc.aws_internet_gateway.this: Still destroying... (ID: igw-069ddee7c85a4a274, 10s elapsed)
module.blog_vpc.aws_internet_gateway.this: Destruction complete after 10s
module.blog_vpc.aws_vpc.this: Destroying... (ID: vpc-06a1a64382adb8ed4)
module.blog_vpc.aws_vpc.this: Destruction complete after 1s

Destroy complete! Resources: 30 destroyed.
```

