
param appName string = 'bottleneck'

param appNodeVersion string = '14.15.1'
param phpVersion string = '7.1'

var webAppName = 'app-${appName}-${uniqueString(resourceGroup().id, appName)}'

var databaseAccountId = 'db-${appName}'
var hostingPlanName = 'plan-${appName}'

param databaseAccountLocation string =resourceGroup().location

resource webApp 'Microsoft.Web/sites@2021-01-15' = {
  name: webAppName
  location: resourceGroup().location
  tags: {
    //This looks nasty, but see here: https://github.com/Azure/bicep/issues/555
    'hidden-related:${hostingPlan.id}': 'empty'
  }
  properties: {
    siteConfig: {
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: AppInsights.properties.InstrumentationKey
        }
        {
          name: 'WEBSITE_NODE_DEFAULT_VERSION'
          value: appNodeVersion
        }
        {
          name: 'CONNECTION_STRING'
          value: first(listConnectionStrings('Microsoft.DocumentDb/databaseAccounts/${databaseAccountId}', '2015-04-08').connectionStrings).connectionString
        }
        {
          name: 'MSDEPLOY_RENAME_LOCKED_FILES'
          value: '1'
        }
      ]
      phpVersion: phpVersion
    }
    serverFarmId: hostingPlan.id
  }
}
output appUrl string = webApp.properties.defaultHostName
output appName string =webApp.name

/*
resource codeDeploy 'Microsoft.Web/sourcecontrols@2018-11-01' = {
  scope: webApp
  name: 'web'
  properties: {
    RepoUrl: 'https://github.com/Gordonby/nodemongosampleapp.git'
    branch: 'main'
    publishRunbook: true
    IsManualIntegration: true
  }
  dependsOn: [
    webApp
  ]
}
*/

// resource webAppAppInsightsLink 'Microsoft.Web/sites/siteextensions@2021-01-15' = {
//   parent: webApp
//   name: 'Microsoft.ApplicationInsights.AzureWebSites'
// }

resource hostingPlan 'Microsoft.Web/serverfarms@2021-01-15' = {
  name: hostingPlanName
  location: resourceGroup().location
  sku: {
    name: 'P2v3'
    tier: 'PremiumV3'
    size: 'P2v3'
    family: 'Pv3'
    capacity: 1
  }
  kind: 'app'
  properties: {
    perSiteScaling: false
    maximumElasticWorkerCount: 1
    isSpot: false
    reserved: false
    isXenon: false
    hyperV: false
    targetWorkerCount: 0
    targetWorkerSizeId: 0
  }
}

resource cosmosDbDatabase 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases@2021-06-15' = {
  parent: cosmosDbAccount
  name: 'sampledatabase'
  properties: {
    resource: {
      id: 'sampledatabase'
    }
    options: {
      //autoscaleSettings: {
      //  maxThroughput: autoscaleMaxThroughput
      //}
    }
  }
}

resource cosmosDbCollection 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections@2021-06-15' = {
  parent: cosmosDbDatabase
  name: 'samplecollection'
  properties: {
    resource: {
      id: 'samplecollection'
      shardKey: {
        user_id: 'Hash'
      }
      indexes: [
        {
          key: {
            keys: [
              '_id'
            ]
          }
        }
      ]
    }
  }
}

resource cosmosDbThroughput 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections/throughputSettings@2021-06-15' = {
  parent: cosmosDbCollection
  name: 'default'
  properties: {
    resource: {
      throughput: 400
    }
  }
}

resource AppInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: webAppName
  location: resourceGroup().location
  kind: 'web'
  tags: {
    //This looks nasty, but see here: https://github.com/Azure/bicep/issues/555
    'hidden-link:${resourceGroup().id}/providers/Microsoft.Web/sites/${webAppName}': 'Resource'
  }
  properties: {
    Application_Type: 'web'
    //applicationId: webAppName
    //Request_Source: 'AzureTfsExtensionAzureProject'
  }
}

resource cosmosDbAccount 'Microsoft.DocumentDB/databaseAccounts@2021-06-15' = {
  kind: 'MongoDB'
  name: databaseAccountId
  location: databaseAccountLocation
  properties: {
    databaseAccountOfferType: 'Standard'
    locations: [
      {
        locationName: '${resourceGroup().location}'
        failoverPriority:0
        isZoneRedundant: false
      }
    ]
  }
}
