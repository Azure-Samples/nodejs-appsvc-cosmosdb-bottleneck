$resourceGroup = "rg-bottleneck"
$deploymentName = "bottleneck"
$location = "westeurope"


Write-Host "Creating resource group " $resourceGroup
az group create --location $location --name $resourceGroup

Write-Host "Deploying Sample application.. (this might take a few minutes)"
$deploymentOutputs = az deployment group create -g $resourceGroup -f ./windows-webapp-template.bicep --parameters "appName=$deploymentName"
$deploymentOutputs = $deploymentOutputs | ConvertFrom-Json
Write-Output $deploymentOutputs

$publishConfig = az webapp deployment list-publishing-credentials -g $rg -n $app | ConvertFrom-Json

Write-Host "Publishing sample app.. (this might take a minute or two)"
git init
git config user.email "you@example.com"
git config user.name "Example man"
git add -A
git commit -m "Initial commit"
git remote add azwebapp $publishConfig.scmUri
git remote rm azwebapp 
git remote add azwebapp $publishConfig.scmUri
git push azwebapp main:master

Write-Host "Deployment Complete"
Write-Host "Open url https://$deploymentName.azurewebsites.net in the browser"
Write-Host "To delete the app, run command 'az group delete --name $resourceGroup'"
