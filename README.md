

# README.md for Riyadh DevOps Project

# Application can be accessed here http://172.168.99.182/

## Project Overview

This repository contains a complete DevOps pipeline and infrastructure setup to deploy a Python web application on Azure Kubernetes Service (AKS) with (CI/CD) powered by GitHub Actions.

Here’s a set of notes on design decisions and key findings, written in a natural style suitable for sharing with a recruiter or as project documentation:

***

## Notes on Design Decisions and Key Findings

### 1. **Choosing Azure AKS with CI/CD**
I selected Azure Kubernetes Service (AKS) for container orchestration to leverage its managed features and smooth integration with other Azure services. Given the requirements for continuous integration and deployment, GitHub Actions became the obvious choice since it’s native to GitHub and works well with Azure resources.

### 2. **Minimal and Secure Docker Images**
In building the Dockerfile, I went with the `python:3.9-slim` base image to keep container size low, which turns out to reduce both attack surface and startup time. Running the code as a non-root user was a simple yet important security step.

### 3. **Smart YAML Design for Kubernetes**
Resource limits and requests in the deployment YAML were carefully tuned due to the tight constraints of the Azure free tier—this was crucial once I hit core and memory quotas. Setting the `replicas` to 1 wasn’t just about passing requirements, but about ensuring the system stayed healthy despite the low resources.

### 4. **Rolling Updates for Zero Downtime**
I selected the rolling update strategy in the deployment manifest. Although I operated mainly with just one replica due to resource limits, specifying rolling updates is a best practice in real-world deployments where scaling is possible.

### 5. **Integration of Code Quality Gates**
Adding SonarQube to the CI/CD pipeline was a major improvement for code quality. Hosting SonarQube on AKS and having the GitHub Actions workflow automatically scan my code means any issues are caught before deployment. I had to securely manage secrets and set up webhook tokens for end-to-end integration.

### 6. **Monitoring, Alerts, and Debugging**
I discovered that AKS and Azure Monitor integrations rely on Log Analytics workspaces. When I first tried to set up pod alerting, I learned that workspaces are tightly bound to the cluster at creation time. The workaround taught me a lot about Azure’s logging model. I also set up CrashLoopBackOff alerts that email me directly, which would be vital in production.



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

## Git Ignore Configuration

To ensure smooth uploads to GitHub and avoid committing large or sensitive files, a `.gitignore` file has been added to this project.

The `.gitignore` excludes:
- Terraform executable binaries (e.g., `terraform.exe`)
- Local environment and configuration files
- Temporary files and build artifacts
- System-specific directories (e.g., `.vscode/`, `.idea/`)

This setup ensures only relevant project code, manifests, and configuration scripts are version-controlled, keeping the repository clean and lightweight.



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








new comment added
new comment added
new comment added
