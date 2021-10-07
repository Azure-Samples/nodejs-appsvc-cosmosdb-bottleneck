param databaseAccountId string
param databaseAccountLocation string =resourceGroup().location

resource databaseAccountId_sampledatabase 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases@2020-06-01-preview' = {
  parent: databaseAccountId_resource
  name: 'sampledatabase'
  properties: {
    resource: {
      id: 'sampledatabase'
    }
    options: {}
  }
}

resource databaseAccountId_sampledatabase_samplecollection 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections@2020-06-01-preview' = {
  parent: databaseAccountId_sampledatabase
  name: 'samplecollection'
  properties: {
    resource: {
      id: 'samplecollection'
      indexes: []
    }
    options: {}
  }
}

resource databaseAccountId_sampledatabase_samplecollection_default 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections/throughputSettings@2020-06-01-preview' = {
  parent: databaseAccountId_sampledatabase_samplecollection
  name: 'default'
  properties: {
    resource: {
      throughput: 400
    }
  }
}

resource databaseAccountId_resource 'Microsoft.DocumentDb/databaseAccounts@2015-04-08' = {
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

output accountId string = databaseAccountId_resource.id
output connstr string = first(listConnectionStrings('Microsoft.DocumentDb/databaseAccounts/${databaseAccountId}', '2015-04-08').connectionStrings).connectionString
