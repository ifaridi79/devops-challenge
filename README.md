# Liatrio devops-challenge

## Azure Subscription for AKS Provisioning

We will be using IaC Terraform tool to provision AKS in Azure subscription and using Python flask for Service using containerized application to deploy using Kubernetes manifest file.

![AKS](images/AKS.jpg?raw=true "GitHub-workflows")    

### Initial Setup for Az Login and Terraform credentials for Local setup:

Here are the steps:

In a terminal, run the following commands to login into Azure. Make sure you have the updated Azure CLI.

1. Install Azure CLI:

        brew update && brew install azure-cli

2. AZ Login to connect to Azure Portal:

        az login

        [
        {
            "cloudName": "AzureCloud",
            "homeTenantId": "541297fa-e50f-4af1-aee8-52c9542c30ce",
            "id": "cb3f5660-48a2-492f-bd16-e2adfe209dc6",
            "isDefault": true,
            "managedByTenants": [],
            "name": "Azure subscription 1",
            "state": "Enabled",
            "tenantId": "541297fa-e50f-4af1-aee8-52c9542c30ce",
            "user": {
            "name": "imran.faridi@gmail.com",
            "type": "user"
            }
        }
        ]

3. Create a role base access control for Terraform. And configure that in Terraform infrastructure file terraform.tfvars:

        az ad sp create-for-rbac --skip-assignment

        {
            "appId": "b9e3ed69-4db2-46d3-91c3-977ec9bb71e0",
            "displayName": "azure-cli-2023-04-26-20-49-01",
            "password": "be78Q~nZKpbxgIDs.CQGwwOAoDTu321mYC72OcR_",
            "tenant": "541297fa-e50f-4af1-aee8-52c9542c30ce"
        }

### GitHub and Terrafrom environment setup:


1. Azure Storage for TF State file: 
Make sure to create a storage container to save Terraform State file in Azure cloud to maintain the state. Here are the steps to create Storage container.

        # Create Resource Group
        az group create -n terraform-github-actions-state-rg -l eastus2

        # Create Storage Account
        az storage account create -n tfstaccount -g terraform-github-actions-state-rg -l eastus2 --sku Standard_LRS

        # Create Storage Account Container
        az storage container create -n tfstate --account-name tfstaccount


2. Setup GitHub Secrets
Setting-up GitHub Action secrets by mapping the above 2 command outputs to the GitHub Secrets. Subscription Id you can findout rom az login output:
Save the above values into GitHub Action Secrets:

        ARM_CLIENT_ID: "${{ secrets.AZURE_CLIENT_ID }}"  // appId
        ARM_SUBSCRIPTION_ID: "${{ secrets.AZURE_SUBSCRIPTION_ID }}" //Azure subscription Id
        ARM_TENANT_ID: "${{ secrets.AZURE_TENANT_ID }}" // tenant
        ARM_CLIENT_SECRET: ${{ secrets.AZURE_CLIENT_SECRET }}     // password

![AKS](images/GitHub-secrets.png?raw=true "Secrets") 

![AKS](images/secrets.png?raw=true "Secrets")  


## GitHub Repository, workflows and Actions for CI/CD pipeline

Git Branching strategy will be Trunk based, where individual contributor will be creating short-lived branch for changes and create a pull request for approval before merging to the main branch. Main branch has protection in placed for approval and review process process.

![Branching strategy](images/trunk-based.jpg#center)

Code structure and GitHub workflow. It comprises of Python code and unit test cases with .py extension, Dockerfile for packaging and containerized the Python flask app with all the dependencies and packaging. There is a requirements.txt file, which lists all the python dependencies. For Kubenertes deployment file with *.yaml mentioned under manifests folder, which will define deployment and roll-out strategy of Docker container in AKS. And finally the workflow pipeline CI/CD is defined declaratively in .yml file under .github/workflows folder using GitHub Actions.

![Code structure](images/code-structure.png?raw=true "code")

## GitHub Workflows Pipeline Summary. 

Comprises of 2 GitHub workflows:

### 1. CI Pipeline

![GitHub](images/CI-pipeline.png?raw=true "CI-pipeline")

### 2. CD Pipeline

![GitHub](images/CD-pipeline.png?raw=true "Deploy-pipeline")


## Details of CI Pipeleine

Triggers on every pull request to validate all the code, unit testing and docker image by publishing into Github Registry.

### 1. Build Code stage: 
Python 3.10 environment, Install the required dependencies, Lint code, and Unit testing

![Build](images/buid-stage.png?raw=true "build code")

### 2. Build & push Docker image: 
Building Docker image, and Pushing into GitHub Registry package manager by tagging

![Docker](images/image-build.png?raw=true "build image")

### 3. Testing container image: 
Pulling the docker image from GitHub registry , and running unit tests on container.

![Testing](images/test-image.png?raw=true "testing image")

## Details of CD Pipeline

Triggers after successfully merge the code into main branch with all tests and validations passed. Terraform calls Azure ARM to Provision AKS cluster in Azure and later on deploy the application code into AKS using deployment manifest file.

### 1. Provisioning AKS using Terrafrom:  
Terraform Initialization, Terraform Validation and Formatting, Terraform Planing, and Terraform Execution by saving State file.   

![AKS](images/Infrastructure-pipeline.png?raw=true "Secrets")  

### 2. Deploying code into AKS: 
Setup kubectl, AKS context, Creating secrets for image registry pull, and Deploy manifest file by creating resources.    
      
![AKS](images/Deploy-pipeline.png?raw=true "Secrets") 


