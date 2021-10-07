# WebApp with Cosmos DB
 
 A sample webapp deployed on app service with cosmos db as database. It counts the number of visitors visiting the page and inserts the same into a sample collection in Cosmos DB.

### Installation

1. In your terminal window, log into Azure and set a subscription(subscription which would contain the webapp) :

        az login
        az account set -s mySubscriptionName

2. Clone the sample application's source repository. The sample application is a Node.js app consisting of an Azure App Service web component and a Cosmos DB database. The repo also contains a PowerShell script that deploys the sample app to your Azure subscription.

        git clone https://github.com/Azure-Samples/nodejs-appsvc-cosmosdb-bottleneck.git

3. Open .\deploymentscript.ps1 and inspect the default resource group and deployment name. This resource group and associated resources will be created in you Azure subscription in the next step.

4. Deploy the sample app using the PowerShell script. (Tip: macOS users can install PowerShell [here](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-macos?view=powershell-7.1)) 

        cd SampleApp
        .\deploymentscript.ps1

5. Once deployment is complete, it will output the domain name of your web app as well as opening a browser and navigating to the app.

## **Clean up resources**       

You may want to delete the resources to avoid to continue incurring charges. Use the `az group delete` command to remove the resource group and all related resources.

        az group delete --name myResourceGroup

Similarly, you can utilize the **Delete resource group** toolbar button on the sample application's resource group to remove all the resources.
