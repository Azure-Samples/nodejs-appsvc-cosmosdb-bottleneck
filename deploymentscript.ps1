$resourceGroup = "rg-bottleneck"
$deploymentName = "bottleneck"
$location = "westeurope"


Write-Output "Creating resource group " $resourceGroup
az group create --location $location --name $resourceGroup

Write-Output "Deploying Sample application.. (this might take a few minutes)"
$deploymentOutputs = az deployment group create -g $resourceGroup -f ./main.bicep --parameters "appName=$deploymentName"
$deploymentOutputs = $deploymentOutputs | ConvertFrom-Json
Write-Output $deploymentOutputs

$appName=$deploymentOutputs.properties.outputs.appName.value
$appUrl=$deploymentOutputs.properties.outputs.appUrl.value

Write-Output "Deployment of $appName Complete"
Start-Process("https://$appUrl")

Write-Output "To delete the app, run command 'az group delete --name $resourceGroup'"
