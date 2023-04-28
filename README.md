# Liatrio devops-challenge

## Azure Subscription for AKS Provisioning

We will be using IaC Terraform tool to provision AKS for our service code.

Here are the steps:

- In a terminal, run the following commands to login into Azure. Make sure you have the updated Azure CLI.

        brew update && brew install azure-cli

        az login
        A web browser has been opened at https://login.microsoftonline.com/organizations/oauth2/v2.0/authorize. Please continue the login in the web browser. If no web browser is available or if the web browser fails to open, use device code flow with `az login --use-device-code`.
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

- Now create a role base access control for Terraform. And configure that in Terraform infrastructure file terraform.tfvars:

        appId    = "b9e3ed69-4db2-46d3-91c3-977ec9bb71e0"
        password = "be78Q~nZKpbxgIDs.CQGwwOAoDTu321mYC72OcR_"

        az ad sp create-for-rbac --skip-assignment
        Option '--skip-assignment' has been deprecated and will be removed in a future release.
        The output includes credentials that you must protect. Be sure that you do not include these credentials in your code or check the credentials into your source control. For more information, see https://aka.ms/azadsp-cli
        {
            "appId": "b9e3ed69-4db2-46d3-91c3-977ec9bb71e0",
            "displayName": "azure-cli-2023-04-26-20-49-01",
            "password": "be78Q~nZKpbxgIDs.CQGwwOAoDTu321mYC72OcR_",
            "tenant": "541297fa-e50f-4af1-aee8-52c9542c30ce"
        }


- Now provision AKS cluster using Terraform. Make sure you have updated terraform CLI:

        terraform -install-autocomplete

- Step 1: Initialize the Provider ARM template:

        terraform init

- Step 2: Plan for the resources to be created in Azure - AKS. You can also save the plan in text file for the reference.        

        terraform plan > aks-plan.txt

- Step 3: Apply changes to the Azure

        terraform apply -auto-approve

        Apply complete! Resources: 3 added, 0 changed, 0 destroyed.

        Outputs:

        kubernetes_cluster_name = "smashing-shrew-aks"
        resource_group_name = "smashing-shrew-rg"
        

## GitHub Repository, workflows and Actions for CI/CD pipeline

- Git Branching strategy will be Trunk based, where individual contributor will be creating short-lived branch for changes and create a pull request for approval before merging to the main branch. Main branch has protection in placed for approval and review process process.

![Branching strategy](trunk-based.jpg?raw=true "Trunk-based")

- Code structure and GitHub workflow. It comprises of Python code and unit test cases with .py extension, Dockerfile for packaging and containerized the Python flask app with all the dependencies and packaging. There is a requirements.txt file, which lists all the python dependencies. For Kubenertes deployment file with *.yaml mentioned under manifests folder, which will define deployment and roll-out strategy of Docker container in AKS. And finally the workflow pipeline CI/CD is defined declaratively in .yml file under .github/workflows folder using GitHub Actions.

![Code structure](code-structure.png?raw=true "code")

- CI/CD Pipeline workflow Summary. Comprises of 4 stages:

![GitHub](pipeline.png?raw=true "workflow")


- Build Code stage: Python 3.10 environment, Install the required dependencies, Lint code, Unit testing

![Build](buid-stage.png?raw=true "build code")

- Build & push Docker image: Building Docker image, and Pushing into GitHub Registry package manager by tagging

![Docker](image-build.png?raw=true "build image")

- Testing container image: Pulling the docker image from GitHub registry , and running unit tests on container.

![Testing](test-image.png?raw=true "testing image")

- Deployment to AKS: Setup kubectl, AKS context, Creating secrets for image registry pull, and Deploy manifest file by creating resources. Make sure you set GitHub secrets by creating AKS credentials with below command. 

- Set Secret with azure Credentils

        az ad sp create-for-rbac --name "devops-challenge" --role contributor \
                                --scopes /subscriptions/cb3f5660-48a2-492f-bd16-e2adfe209dc6/resourceGroups/smashing-shrew-rg \
                                --sdk-auth

        {
            "clientId": "720f34ab-9d08-43f3-901d-88d77ca9270a",
            "clientSecret": "eFo8Q~akXAJAZivZ-axVIHlIRPnMlJvFJ52iAcFv",
            "subscriptionId": "cb3f5660-48a2-492f-bd16-e2adfe209dc6",
            "tenantId": "541297fa-e50f-4af1-aee8-52c9542c30ce",
            "activeDirectoryEndpointUrl": "https://login.microsoftonline.com",
            "resourceManagerEndpointUrl": "https://management.azure.com/",
            "activeDirectoryGraphResourceId": "https://graph.windows.net/",
            "sqlManagementEndpointUrl": "https://management.core.windows.net:8443/",
            "galleryEndpointUrl": "https://gallery.azure.com/",
            "managementEndpointUrl": "https://management.core.windows.net/"
        }                        

![AKS](deployment.png?raw=true "Deploy")        