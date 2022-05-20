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

## Load Test automation with GitHub Actions

It is often useful to be able to do some form of load test of a new application deployment. Azure load test achieves this with a [GitHub Action](https://docs.microsoft.com/en-us/azure/load-testing/tutorial-cicd-github-actions). This may be used to drive a load test, but to also set some pass/fail criteria for the load test - allowing the action to report success or failure depending on whether the load test criteria are met or not.

Besides the JMX file which defines the actual load test, there are 2 other files involved:
1. The load test YAML
2. The GitHib action which references the load test YAML definition.

### Load test YAML

The YAML file defines how to run the load test. A sample YAML is shown below:

```
version: v0.1
testName: SampleAppTestParam
testPlan: SampleAppParam.jmx
description: 'SampleApp Test Run'
engineInstances: 1
failureCriteria: 
- avg(response_time_ms) > 5000
- percentage(error) > 20
```

Looking at the above YAML file:
1. This names and describes the load test
2. Which JMeter JMX file this will use
3. How many engine instances to run the load test
4. Some failure criteria. In this case, if the average response time is greater than 5 seconds or that the error is greater than 20%, the test fails.


### The GitHub Action

Below is the GitHib Action step that does the load testing:

```
- name: 'Azure Load Testing'
        uses: azure/load-testing@v1
        with:
          loadTestConfigFile: 'SampleApp.yaml'
          loadTestResource: ${{ env.LOAD_TEST_RESOURCE }}
          resourceGroup: ${{ env.LOAD_TEST_RESOURCE_GROUP }}
          env: |
            [
              {
                 "name": "webapp",
                 "value": "${{env.ENDPOINT_URL}}"
              }
            ]
```

Looking at the action above:
1. it points to the YAML file which describes the test
2. It points to the name of the Azure load test service - which must have been previously provisioned
3. Sets an environment variable "webapp" into the load test with the endpoint of the system under test. 
