# WebApp with Cosmos DB
 
 A sample webapp deployed on app service with cosmos db as database. It counts the number of visitors visiting the page and inserts the same into a sample collection in Cosmos DB.

### Installation

1. In your terminal window, log into Azure and set a subscription(subscription which would contain the webapp) :

        az login
        az account set -s mySubscriptionName

2. Clone the sample application's source repository. The sample application is a Node.js app consisting of an Azure App Service web component and a Cosmos DB database. The repo also contains a PowerShell script that deploys the sample app to your Azure subscription.

        git clone https://github.com/Azure-Samples/nodejs-appsvc-cosmosdb-bottleneck.git

3. Deploy the sample app using the PowerShell script. (Tip: macOS users can install PowerShell [here](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-macos?view=powershell-7.1))

        cd SampleApp
        .\deploymentscript.ps1

4. You will be prompted to supply a unique application name and a location (default is `eastus`). A resource group for the resources would be created with the same name.
5. Once deployment is complete, browse to the running sample application with your browser.

        https://<app_name>.azurewebsites.net
## **Clean up resources**       

You may want to delete the resources to avoid to continue incurring charges. Use the `az group delete` command to remove the resource group and all related resources.

        az group delete --name myResourceGroup

Similarly, you can utilize the **Delete resource group** toolbar button on the sample application's resource group to remove all the resources.
