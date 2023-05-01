# Liatrio devops-challenge

## Azure Subscription for AKS Provisioning

We will be using IaC Terraform tool to provision AKS in Azure subscription and using Python flask for Service using containerized application to deploy using Kubernetes manifest file.

![AKS](images/AKS.jpg?raw=true "GitHub-workflows")    

### Initial Setup for Az Login and Terraform credentials:

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
        Option '--skip-assignment' has been deprecated and will be removed in a future release.
        The output includes credentials that you must protect. Be sure that you do not include these credentials in your code or check the credentials into your source control. For more information, see https://aka.ms/azadsp-cli
        {
            "appId": "b9e3ed69-4db2-46d3-91c3-977ec9bb71e0",
            "displayName": "azure-cli-2023-04-26-20-49-01",
            "password": "be78Q~nZKpbxgIDs.CQGwwOAoDTu321mYC72OcR_",
            "tenant": "541297fa-e50f-4af1-aee8-52c9542c30ce"
        }


## GitHub Repository, workflows and Actions for CI/CD pipeline

Git Branching strategy will be Trunk based, where individual contributor will be creating short-lived branch for changes and create a pull request for approval before merging to the main branch. Main branch has protection in placed for approval and review process process.

![Branching strategy](images/trunk-based.jpg#center)

Code structure and GitHub workflow. It comprises of Python code and unit test cases with .py extension, Dockerfile for packaging and containerized the Python flask app with all the dependencies and packaging. There is a requirements.txt file, which lists all the python dependencies. For Kubenertes deployment file with *.yaml mentioned under manifests folder, which will define deployment and roll-out strategy of Docker container in AKS. And finally the workflow pipeline CI/CD is defined declaratively in .yml file under .github/workflows folder using GitHub Actions.

![Code structure](images/code-structure.png?raw=true "code")

## GitHub Workflows Pipeline Summary. 

Comprises of 3 GitHub workflows:

### 1. CI Pipeline

![GitHub](images/CI-pipeline.png?raw=true "CI-pipeline")

### 2. Infrastructure Pipeline

![GitHub](images/Infrastructure-pipeline.png?raw=true "Infra-pipeline")

### 3. Deploy Pipeline

![GitHub](images/Deploy-pipeline.png?raw=true "Deploy-pipeline")


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

## Details of Infrastructure Pipeline

Triggers after successfully merge the code into main branch with all tests and validations passed. Terraform calls Azure ARM to Provision AKS cluster in Azure.

### 1. Azure Storage for TF State file: 

Make sure to create a storage container to save Terraform State file in Azure cloud to maintain the state. Here are the steps to create Storage container.

```
# Create Resource Group
az group create -n terraform-github-actions-state-rg -l eastus2

# Create Storage Account
az storage account create -n tfstaccount -g terraform-github-actions-state-rg -l eastus2 --sku Standard_LRS

# Create Storage Account Container
az storage container create -n tfstate --account-name tfstaccount
```

### 2. Infrstructure Provisioning: 
Terraform Initialization, Terraform Validation and Formatting, Terraform Planing, and Terraform Execution by saving State file. 

## Details of Deployment Pipeline

### Deployment to AKS: 
Setup kubectl, AKS context, Creating secrets for image registry pull, and Deploy manifest file by creating resources.  

Deployment pipeline is dependent on Infrastructure pipeline workflow.

Prerequisite: Setup Secret with azure Credentils in GitHub Action using Environment 'Azure' after creating Azure K8 clusters from Infrastructure pipeline. Here are the following steps: 

### 1. Create Service Principal using the following AZ CLI command:

```
az ad sp create-for-rbac --name "devops-challenge" --role contributor \
                                --scopes /subscriptions/cb3f5660-48a2-492f-bd16-e2adfe209dc6/resourceGroups/smashing-shrew-rg \
                                --sdk-auth

{
  "clientId": "2dbde139-23a1-4fd9-951b-37a30d4a0b7f",
  "clientSecret": "Dvj8Q~DBdEiEqwmXrM2oM-rS9U3~jpMYJyWq9c.w",
  "subscriptionId": "cb3f5660-48a2-492f-bd16-e2adfe209dc6",
  "tenantId": "541297fa-e50f-4af1-aee8-52c9542c30ce",
  "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
  "resourceManagerEndpointUrl": "https://management.azure.com/",
  "activeDirectoryGraphResourceId": "https://graph.windows.net/",
  "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
  "galleryEndpointUrl": "https://gallery.azure.com/",
  "managementEndpointUrl": "https://management.core.windows.net/"
}                                
```

### 2. Create Secrets in GitHub Environment by copying the output into GitHub Secrets variable:

![AKS](images/secrets.png?raw=true "Secrets")    
      



