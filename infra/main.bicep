param location string = resourceGroup().location
param appName string
param acrName string
param planName string
param dockerImage string
@secure()
param mongodbUri string
param port string = '3000'

resource acr 'Microsoft.ContainerRegistry/registries@2023-01-01-preview' = {
  name: acrName
  location: location
  sku: {
    name: 'Basic'
  }
  properties: {
    adminUserEnabled: true
  }
}

resource plan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: planName
  location: location
  sku: {
    name: 'F1'
    tier: 'Free'
  }
  kind: 'linux'
  properties: {
    reserved: true
  }
}

resource webapp 'Microsoft.Web/sites@2022-09-01' = {
  name: appName
  location: location
  kind: 'app,linux,container'
  properties: {
    serverFarmId: plan.id
    siteConfig: {
      linuxFxVersion: 'DOCKER|${dockerImage}'
      appSettings: [
        {
          name: 'MONGODB_URI'
          value: mongodbUri
        }
        {
          name: 'PORT'
          value: port
        }
        {
          name: 'WEBSITES_PORT'
          value: port
        }
      ]
    }
  }
}

output acrLoginServer string = acr.properties.loginServer
output webappDefaultHostName string = webapp.properties.defaultHostName
