# WebApp with Cosmos DB

A sample web app deployed on Azure App Service with a Cosmos DB database. The app counts the number of visitors visiting the page and inserts the same number of entries into a sample collection in Cosmos DB.

This sample application is used in the [Azure Load Testing tutorial about identifying performance bottlenecks](https://learn.microsoft.com/azure/load-testing/tutorial-identify-bottlenecks-azure-portal).

## Deployment

To deploy the sample application to Azure, you'll use the Azure Developer CLI (azd). Check out the [Azure Dev CLI documentation for more instructions on using the CLI](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/get-started).

1. Run the following command to initialize the project.

    ```bash
    azd init --template https://github.com/Azure-Samples/nodejs-appsvc-cosmosdb-bottleneck/tree/azd
    ```

    This command will clone the code to your current folder and prompt you for the following information:

    - `Environment Name`: This will be used as a prefix for the resource group that will be created to hold all Azure resources. This name should be unique within your Azure subscription.

1. Run the following command to build a deployable copy of your application, provision the template's infrastructure to Azure and also deploy the application code to those newly provisioned resources.

    ```bash
    azd up
    ```

    This command will prompt you for the following information:

    - `Azure Subscription`: The Azure Subscription where your resources will be deployed.
    - `Azure Location`: The Azure location where your resources will be deployed.

    > NOTE: This may take a while to complete as it executes three commands: `azd package` (builds a deployable copy of your application), `azd provision` (provisions Azure resources), and `azd deploy` (deploys application code). You will see a progress indicator as it packages, provisions and deploys your application.

1. Once deployment is complete, you can browse to the running sample application.

    https://<app_name>.azurewebsites.net

## Clean up resources

You may want to delete the resources to avoid to continue incurring charges. Use the `az group delete` command to remove the resource group and all related resources.

```bash
azd down
```

Alternately, you can use the **Delete resource group** toolbar button in the Azure portal on the sample application's resource group to remove all the resources.
