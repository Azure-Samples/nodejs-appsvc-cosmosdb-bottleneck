// This file uses the newer API's for Cosmos, however the node app doesn't cope well
// Leaving the file here for reference, but know that it's not used by main.bicep

@description('Name of the CosmosDb Account')
param databaseAccountId string

param databaseAccountLocation string =resourceGroup().location

param databaseName string = 'sampledatabase'
param collectionName string = 'samplecollection'

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
output databaseAccountId string = cosmosDbAccount.id

resource cosmosDbThroughput 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections/throughputSettings@2021-06-15' = {
  parent: cosmosDbCollection
  name: 'default'
  properties: {
    resource: {
      throughput: 400
    }
  }
}

resource cosmosDbDatabase 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases@2021-06-15' = {
  parent: cosmosDbAccount
  name: databaseName
  properties: {
    resource: {
      id: databaseName
    }
  }
}

resource cosmosDbCollection 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections@2021-06-15' = {
  parent: cosmosDbDatabase
  name: collectionName
  properties: {
    resource: {
      id: collectionName
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

output accountId string = cosmosDbDatabase.id
output connstr string = first(listConnectionStrings('Microsoft.DocumentDb/databaseAccounts/${databaseAccountId}', '2015-04-08').connectionStrings).connectionString
