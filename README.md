# Liatrio devops-challenge

## Azzure Subscription
Here are the steps:

- In a terminal, run the following commands to login into Azure

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

- Now create a role base access control.

        az ad sp create-for-rbac --skip-assignment
        Option '--skip-assignment' has been deprecated and will be removed in a future release.
        The output includes credentials that you must protect. Be sure that you do not include these credentials in your code or check the credentials into your source control. For more information, see https://aka.ms/azadsp-cli
        {
            "appId": "b9e3ed69-4db2-46d3-91c3-977ec9bb71e0",
            "displayName": "azure-cli-2023-04-26-20-49-01",
            "password": "be78Q~nZKpbxgIDs.CQGwwOAoDTu321mYC72OcR_",
            "tenant": "541297fa-e50f-4af1-aee8-52c9542c30ce"
        }
