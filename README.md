# AWS EKS Cluster Creation with Terraform and OpenTofu

This repository provides a demonstration of how to create and configure an **AWS EKS (Elastic Kubernetes Service)** cluster using **Terraform**. The goal is to showcase the process of provisioning an EKS cluster in AWS and configuring it for Kubernetes deployments.

## Table of Contents
1. [Prerequisites](#prerequisites)
2. [Getting Started](#getting-started)
3. [Terraform Configuration](#terrafrom-configuration)
4. [Deploying the EKS Cluster](#deploying-the-eks-cluster)
5. [Post-Deployment Steps](#post-deployment-steps)
6. [Monitoring & Logging](#monitoring--logging)
7. [Clean Up](#clean-up)

---

## Prerequisites

Before you start, make sure you have the following tools installed:

- **Terraform** (v1.4.5 or later)
- **AWS CLI** (v2 or later)
- **kubectl**
- **k9s** (optional, for cluster management)
- **Helm** (for deploying additional resources)

### Setup AWS CLI and Terraform
1. **Configure AWS CLI**:
   ```bash
   aws configure
   ```

2. **Install OpenTofu**:
   Download and install OpenTofu from the official site: [OpenTofu Install](https://opentofu.org/docs/intro/install)

3. **Install Terraform**:
   Download and install Terraform from the official site: [Terraform Install](https://www.terraform.io/downloads.html)

4. **Install kubectl**:
   Follow the installation instructions for kubectl: [kubectl Install](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

5. **Install k9s**:
   ```bash
   curl -Lo k9s.tar.gz https://github.com/derailed/k9s/releases/download/v0.27.4/k9s_Linux_x86_64.tar.gz &&    tar -xvf k9s.tar.gz -C /usr/local/bin &&    rm k9s.tar.gz
   ```

---

## Getting Started

1. **Clone the repository**:
   ```bash
   git clone https://github.com/sahotay/eks-opentofu-terraform.git
   cd eks-opentofu-terraform
   ```

2. **Set your AWS region** (optional):
   Set your AWS region by modifying the Terraform configuration or setting the AWS CLI region:
   ```bash
   export AWS_REGION=us-east-2
   ```

---

## Terraform Configuration

This repository includes Terraform/OpenTofu configuration files that define the AWS infrastructure required to create an EKS cluster:

- **`main.tf`**: Defines the main AWS resources like VPC, subnets, and security groups.
- **`eks-cluster.tf`**: Contains the configuration for the EKS cluster itself.
- **`outputs.tf`**: Outputs useful information like the EKS cluster name and Kubernetes config.
- **`variables.tf`**: Defines input variables for the cluster configuration.

---

## Deploying the EKS Cluster

1. **Initialize Terraform**:
   Initialize the Terraform working directory to download provider plugins and set up the backend:
   ```bash
   terraform init
   ```

2. **Plan the Deployment**:
   Run a Terraform plan to review the resources that will be created:
   ```bash
   terraform plan
   ```

3. **Apply the Terraform Configuration**:
   Apply the Terraform configuration to create the EKS cluster:
   ```bash
   terraform apply
   ```
   Confirm the apply action when prompted.

4. **Verify the EKS Cluster**:
   After the deployment completes, configure kubectl to access the new EKS cluster:
   ```bash
   aws eks --region $AWS_REGION update-kubeconfig --name <your-cluster-name>
   ```

5. **Check the Cluster**:
   Verify the cluster is accessible:
   ```bash
   kubectl get nodes
   ```

   This command should display the nodes of your EKS cluster.

---

## Post-Deployment Steps

After the EKS cluster is created, you can deploy additional resources and configurations:

1. **Helm Installations**:
   Install Helm and deploy Kubernetes applications (e.g., Prometheus, NGINX ingress controller, etc.):
   ```bash
   helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
   helm install prometheus prometheus-community/kube-prometheus-stack
   ```

2. **Deploy Applications to EKS**:
   You can now deploy your applications using `kubectl apply` or Helm charts.

3. **Install K9s (Optional)**:
   K9s is a great tool to manage and interact with your Kubernetes clusters. Start it with:
   ```bash
   k9s
   ```

---

## Monitoring & Logging

To monitor and log EKS cluster activity, you can integrate tools like Prometheus, Grafana, Fluent Bit, and more.

1. **Prometheus**: Use Helm to deploy Prometheus to your EKS cluster.
2. **Grafana**: Monitor your EKS cluster and applications using Grafana dashboards.
3. **Fluent Bit**: Collect and forward logs from your Kubernetes pods.

---

## Clean Up

To delete the resources created by terraform, run:

```bash
terraform destroy
```

This will remove the EKS cluster and all related AWS resources.

---
