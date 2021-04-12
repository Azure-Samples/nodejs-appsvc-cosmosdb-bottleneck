﻿function Get-UrlStatusCode([string] $Url)
{
    try
    {
        [System.Net.WebRequest]::Create($Url).GetResponse()
    }
    catch [Net.WebException]
    {
        [int]$_.Exception.Response.StatusCode
    }
}

$ErrorActionPreference = "Stop"
[Console]::ResetColor()
# az login --use-device-code
$output = az account show | ConvertFrom-Json
$subscriptionList = az account list | ConvertFrom-Json 
$subscriptionList | Format-Table name, id, tenantId -AutoSize
$selectedSubscription = $output.name
Write-Host "Currently logged in to subscription """$output.name.Trim()""" in tenant " $output.tenantId
$selectedSubscription = Read-Host "Enter subscription Id ("$output.id")"
$selectedSubscription = $selectedSubscription.Trim()
if([string]::IsNullOrWhiteSpace($selectedSubscription)) {
    $selectedSubscription = $output.id
} else {
    # az account set --subscription $selectedSubscription
    Write-Host "Changed to subscription ("$selectedSubscription")"
}

while($true) {
    $deploymentName = Read-Host -Prompt "Enter webapp name"
    $deploymentName = $deploymentName.Trim()
    if($deploymentName.ToLower() -match "xbox") {
        Write-Host "Webapp name cannot have keywords xbox,windows,login,microsoft"
        continue
    } elseif ($deploymentName.ToLower() -match "windows") {
        Write-Host "Webapp name cannot have keywords xbox,windows,login,microsoft"
        continue
    } elseif ($deploymentName.ToLower() -match "login") {
        Write-Host "Webapp name cannot have keywords xbox,windows,login,microsoft"
        continue
    } elseif ($deploymentName.ToLower() -match "microsoft") {
        Write-Host "Webapp name cannot have keywords xbox,windows,login,microsoft"
        continue
    }
    # Create the request
    $HTTP_Status = Get-UrlStatusCode('http://' + $deploymentName + '.azurewebsites.net')
    if($HTTP_Status -eq 0) {
        break
    } else {
        Write-Host "Webapp name taken"
    }
}

$location = Read-Host -Prompt "Enter location (eastus)"
$location = $location.Trim()
if([string]::IsNullOrWhiteSpace($location)) {
    $location = "eastus"
}

$resourceGroup = $deploymentName + "-rg"
Write-Host "Creating resource group " $resourceGroup
az group create --location $location --name $resourceGroup --subscription $selectedSubscription
$databaseName = $deploymentName + "db"

Write-Host "Deploying Sample application.. (this might take a few minutes)"
$deploymentOutputs = az deployment group create --resource-group $resourceGroup --subscription $selectedSubscription --mode Incremental --template-file ./windows-webapp-template.json --parameters "webAppName=$deploymentName" --parameters "hostingPlanName=$deploymentName-host" --parameters "appInsightsLocation=$location" --parameters "databaseAccountId=$databaseName" --parameters "databaseAccountLocation=$location"
$deploymentOutputs = $deploymentOutputs | ConvertFrom-Json
$connectionString = $deploymentOutputs.properties.outputs.azureCosmosDBAccountKeys.value.connectionStrings[0].connectionString

Write-Host "Setting connection string to cosmos db"
$setConnectionString = az webapp config appsettings set --name $deploymentName --resource-group $resourceGroup --subscription $selectedSubscription --settings CONNECTION_STRING="$connectionString"

Write-Host "Setting app setting for App Service"
$setAppSettings = az webapp config appsettings set --name $deploymentName --resource-group $resourceGroup --subscription $selectedSubscription --settings MSDEPLOY_RENAME_LOCKED_FILES=1

$publishConfig = az webapp deployment list-publishing-credentials --name $deploymentName --resource-group $resourceGroup --subscription $selectedSubscription | ConvertFrom-Json

Write-Host "Publishing sample app.. (this might take a minute or two)"
git init
git config user.email "you@example.com"
git config user.name "Example man"
git add -A
git commit -m "Initial commit"
$a = git remote add azwebapp $publishConfig.scmUri
git remote rm azwebapp 
git remote add azwebapp $publishConfig.scmUri
git push azwebapp main

Write-Host "Deployment Complete"
Write-Host "Open url https://$deploymentName.azurewebsites.net in the browser"
Write-Host "To delete the app, run command 'az group delete --name $resourceGroup'"
