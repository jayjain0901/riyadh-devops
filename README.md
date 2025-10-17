# README.md for Riyadh DevOps Project



## Project Overview

This repository contains a complete DevOps pipeline and infrastructure setup to deploy a Python web application on Azure Kubernetes Service (AKS) with (CI/CD) powered by GitHub Actions.



## Project Structure

- `.github/workflows/deploy.yml` – GitHub Actions workflow for CI/CD including Docker image build, push to Azure Container Registry (ACR), and deployment on AKS.
- `Dockerfile` – application container image with Python 3.9 slim, app dependencies, non-root user, health check, and exposed port.
- `app.py` –  Python web application code.
- `deployment.yaml` – Kubernetes deployment and service manifests.
- `namespace.yaml` –  namespace .
- `terraform/` – Terraform scripts to provision Azure infrastructure Resouce group, AKS, ACR
- `requirements.txt` – Python dependencies list.



## Prerequisites

- Azure subscription (User Free Tier).
- Azure CLI installed and logged in VSC.
- Kubectl installed.
- GitHub repository.
- Azure VM (ubuntu)



## Setup Steps

### 1. Provision Infrastructure with Terraform

- Navigate to `terraform/` folder.
- Update variables if needed (`variables.tf`).
- Run:
  ```bash
  terraform init
  terraform apply
  ```
- This will create resource group, AKS, ACR in Central US region

### 2. Configure GitHub Secrets

Add these secrets to your GitHub repo for CI/CD:

 Secret Name         |  Description                                    
                     |
 `AZURE_CREDENTIALS` |  JSON of your Azure Service Principal credentials. 
 `ACR_NAME`          |  Name of your Azure Container Registry.    

 {
   "clientId": "",
   "clientSecret": "",
   "subscriptionId": "",
   "tenantId": "",
   "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
   "resourceManagerEndpointUrl": "https://management.azure.com/",
   "activeDirectoryGraphResourceId": "https://graph.windows.net/",
   "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
   "galleryEndpointUrl": "https://gallery.azure.com/",
   "managementEndpointUrl": "https://management.core.windows.net/"
 }      

### 3. Build and Deploy via GitHub Actions

- Push code changes to trigger the `.github/workflows/deploy.yml` workflow.
- The pipeline builds Docker image, pushes to ACR, and deploys to AKS.
- Monitor workflow progress from GitHub Actions tab.

### 4. Verify Deployment and Access

- Get service external IP:
  ```bash
  kubectl get svc -n <namespace>
  ```
- Access app via browser at `http://<external-ip>`.


## Additional Features

### SonarQube Integration

- SonarQube can be deployed on AKS to manage code quality.
- Integrate SonarQube scan steps in GitHub Actions.
- Secure SonarQube dashboard with LoadBalancer service & external IP.

### Monitoring and Alerts

- Azure Monitor configured with AKS logs.
- Create alerts for pod CrashLoopBackOff statuses.
- Email notifications can be set up via Azure Action Groups.

## Monitoring with Prometheus and Grafana

- Prometheus and Grafana are deployed in the `monitoring` namespace via Helm.
- Access both using `kubectl port-forward` on local machine:
  - Prometheus: `kubectl port-forward svc/prometheus-stack-kube-prom-prometheus -n monitoring 9090:9090`
  - Grafana: `kubectl port-forward svc/prometheus-stack-grafana -n monitoring 3000:80`
- Grafana connects to Prometheus using the internal cluster URL.

This setup enables cluster metrics visualization without complex setup during development.

## Dockerfile Summary

- Python 3.9 slim base image.
- Copies `requirements.txt` & installs dependencies (cache optimized).
- Runs app as non-root user for security.
- Exposes port 5000.
- Implements health check endpoint polling.



## Key Considerations

- Free tier Azure subscriptions have low CPU/core limits scale deployments accordingly.
- CI/CD credentials and secrets must be securely handled.
- Monitor pod statuses; resolve Pending or CrashLoopBackOff before deploying more replicas.


