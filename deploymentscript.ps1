$resourceGroup = "rg-bottleneck"
$deploymentName = "bottleneck4"
$location = "westeurope"


Write-Output "Creating resource group " $resourceGroup
az group create --location $location --name $resourceGroup

Write-Output "Deploying Sample application.. (this might take a few minutes)"
$deploymentOutputs = az deployment group create -g $resourceGroup -f ./windows-webapp-template.bicep --parameters "appName=$deploymentName"
$deploymentOutputs = $deploymentOutputs | ConvertFrom-Json
Write-Output $deploymentOutputs

$appName=$deploymentOutputs.properties.outputs.appName.value
$appUrl=$deploymentOutputs.properties.outputs.appUrl.value

Write-Output "Getting WebApp Publish Config for $appName"
$publishConfig = az webapp deployment list-publishing-credentials -n $appName -g $resourceGroup | ConvertFrom-Json

# Compress-Archive -Path '*' -DestinationPath c:\Temp\$appName.zip -update
# Test-Path c:\Temp\$appName.zip
# az webapp deploy -g $resourceGroup -n $appName --type zip --clean true --src-path c:\Temp\$appName.zip

#  $publishUrl = az webapp deployment source config-local-git -n $appName -g $resourceGroup -o tsv
#  git remote add azure $publishUrl 
#  git push azure main:master

#  az webapp deployment source config  -n $appName -g $resourceGroup --repo-url 'https://github.com/Gordonby/nodejs-appsvc-cosmosdb-bottleneck.git' --branch 'main'--repository-type github



if ($null -ne $publishConfig) {
    Write-Output "Publishing sample app.. (this might take a minute or two)"
    git init
    git config user.email "you@example.com"
    git config user.name "Example man"
    git add -A
    git commit -m "Initial commit"
    git remote add azwebapp $publishConfig.scmUri
    git remote rm azwebapp 
    git remote add azwebapp $publishConfig.scmUri
    git push azwebapp main:master

     Write-Output "Deployment Complete"
     Write-Output "Open url https://$appUrl in the browser"
     Start-Process("https://$appUrl")
}
Write-Output "To delete the app, run command 'az group delete --name $resourceGroup'"
