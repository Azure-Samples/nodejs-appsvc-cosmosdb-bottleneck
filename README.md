# Webapp with a cosmos Db
 
 A sample webapp deployed on app service with cosmos db as backend. It counts the number of visitors visiting the page and inserts the same to a sample collection on cosmos db.

### Installation

1. In your terminal window, log into Azure and set the susbscription to the one that is whitelisted to use the load test service private preview:

        az login
        az account set -s mySubscriptionName

2. Clone the sample application's source repository. The sample application is a Node.js app consisting of an Azure App Service web component and a Cosmos DB database. The also repo contains a PowerShell script that deploys the sample app to your Azure subscription, and a JMeter script that we'll use in subsequent steps.

        git clone https://github.com/Azure-Samples/nodejs-appsvc-cosmosdb-bottleneck.git

3. Deploy the sample app using the PowerShell script. (Tip: macOS users can install PowerShell [here](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-macos?view=powershell-7.1))

        cd SampleApp
        .\deploymentscript.ps1

4. You will be prompted to supply a unique application name and a location (default is `eastus`).

5. Once deployment is complete, browse to the running sample application with your browser.

        https://<app_name>.azurewebsites.net
