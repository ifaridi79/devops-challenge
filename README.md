# Azure DevOps

## Azure Subscription for AKS Provisioning

We will be using IaC Terraform tool to provision AKS in Azure subscription and using Python flask for Service using containerized application to deploy using Kubernetes manifest file.

![AKS](images/AKS.jpg?raw=true "GitHub-workflows")    

### Local setup on Terminal for Developer:
This will be a Python Flask Application shows the current time stamp on every request.

Prequisite:
Install git locally for git clone and code checkin. Install homebrew if you don't already have it, then: 

1. Use this link: https://git-scm.com/download/mac

        brew install git

2. Clone the git repository:

        git clone https://github.com/ifaridi79/devops-challenge.git

Setup local environment:

1. Setup Python 3 and Pip(Package manager) for Environment(MacOS):

        brew install python
        python --version
        pip --version

2. Install Python dependencies using Package manager:
All dependencies are defined in requiremnets.txt

        pip install -r requirements.txt        

3. Run and test Python Flask application locally:

        python app.py
        python -m unittest --verbose --failfast


4. Setup Local Docker Environment(MacOS):
Download Docker for Mac from https://docs.docker.com/desktop/install/mac-install/ and follow the instructions. After verfied the Docker installation you can now create a Dockerfile to containerized the Python Flask Application. Create a Dockerfile and add the runtime libraries and dependecies.

        touch Dockerfile

5. Here is the Dockerfile code snippet:

        # Use Python base image
        FROM python:3.6

        # Install runtime libraries and dependencies
        WORKDIR /flask
        COPY . /flask
        RUN pip install --upgrade --requirement requirements.txt

        # Execute the flask App
        EXPOSE 8080
        ENTRYPOINT [ "python" ]
        HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD [ "curl --fail http://localhost:8080/ || exit 1" ]
        CMD [ "/flask/app.py" ]

6. Build the Docker Image with tag locally:

        docker build -t app-flask .

7. Run the Docker container from Image by mapping the host port to container port:

        docker run -dp 80:8080 app-flask


### Initial Setup for Az Login and Terraform credentials for Local setup for DevOps:

Here are the steps:

In a terminal, run the following commands to login into Azure. Make sure you have the updated Azure CLI.

1. Install Azure CLI:

        brew update && brew install azure-cli

2. AZ Login to connect to Azure Portal:

        az login

        [
        {
            "cloudName": "AzureCloud",
            "homeTenantId": "<tenant_id_place_holder>",
            "id": "<subscription_id>",
            "isDefault": true,
            "managedByTenants": [],
            "name": "<Azure_Subscription_name>",
            "state": "Enabled",
            "tenantId": "<tenant_id_place_holder>",
            "user": {
            "name": "<user_id>",
            "type": "user"
            }
        }
        ]

3. Create a role base access control for Terraform. Use appId and password as an input variable when using terraform locally:

        az ad sp create-for-rbac --skip-assignment

        {
            "appId": "<app_id_place_holder>",
            "displayName": "<display_name>",
            "password": "<password_place_holder>",
            "tenant": "<tenant_id_place_holder>"
        }

4. Connect to AKS from you local terminal:

        az aks get-credentials --resource-group terraform-github-actions-rg --name terraform-resource-aks

### Terrafrom environment setup for DevOps:     

1. Azure Storage for Backend Remote TF State file: 
Make sure to create a storage container to save Terraform State file in Azure cloud to maintain the state. Here are the steps to create Storage container.

        # Create Resource Group
        az group create -n terraform-github-actions-state-rg -l eastus2

        # Create Storage Account
        az storage account create -n tfstaccount -g terraform-github-actions-state-rg -l eastus2 --sku Standard_LRS

        # Create Storage Account Container
        az storage container create -n tfstate --account-name tfstaccount


2. Terraform CLI useful commands:
Note: Make sure to login into Azure Cloud using az login.

        terraform init

        terraform plan -var ARM_CLIENT_ID=<appId_place_holder> -var ARM_CLIENT_SECRET=<password_place_holder>

        terraform apply -var ARM_CLIENT_ID=<appId_place_holder> -var ARM_CLIENT_SECRET=<password_place_holder>  -auto-approve  

        terraform state   

3. Destroy resources from your local terminal:        

        terraform destroy -var ARM_CLIENT_ID=<appId_place_holder> -var ARM_CLIENT_SECRET=<password_place_holder> -auto-approve

### GitHub environment setup for DevOps:

1. Setup GitHub Secrets:
Setting-up GitHub Action secrets by mapping the above 2 command outputs to the GitHub Secrets. Subscription Id you can findout rom az login output:
Save the above values into GitHub Action Secrets:

        ARM_CLIENT_ID: "${{ secrets.AZURE_CLIENT_ID }}"  // appId
        ARM_SUBSCRIPTION_ID: "${{ secrets.AZURE_SUBSCRIPTION_ID }}" //Azure subscription Id
        ARM_TENANT_ID: "${{ secrets.AZURE_TENANT_ID }}" // tenant
        ARM_CLIENT_SECRET: ${{ secrets.AZURE_CLIENT_SECRET }}     // password

![AKS](images/GitHub-secrets.png?raw=true "Secrets") 

3. Create GitHub Token:
Go to the Tokens page in your Terraform Cloud User Settings. Click on Create an API token and generate an API token named GitHub.

![GitHub](images/GitHub_token.png?raw=true "Token")  


## GitHub Repository, workflows and Actions for CI/CD pipeline for DevOps:

Git Branching strategy will be Trunk based, where individual contributor will be creating short-lived branch for changes and create a pull request for approval before merging to the main branch. Main branch has protection in placed for approval and review process process.

![Branching strategy](images/trunk-based.png#center)

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

![AKS](images/Infrastructure-pipeline.png?raw=true "Infra Pipeline")  

### 2. Deploying code into AKS: 
Setup kubectl, AKS context, Creating secrets for image registry pull, and Deploy manifest file by creating resources.    

1. Create Kubernetes Manifest files:
Using Service as a Load Balancer, service port mapping to container port in service.yml.

        Deployment.yml
        Service.yml

        ports:
          - port: 80
          targetPort: 8080

![AKS](images/K8-Deployment.png?raw=true "K8 Deployment")           
      
![AKS](images/Deploy-pipeline.png?raw=true "CD Pipeline") 



## !!!Bonus!!!
Added Release Pipeline with Docker image Release Tag


