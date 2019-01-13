### Section 1:
### =============================================
### This section includes commands to:
###  1 - Create a Virtual Network and 2 Subnets
###  2 - Create a Storage Account
### =============================================
### Define Deployment Variables
{
$resourceGroupName = 'rg585563'
$resourceProviderNamespace = 'Microsoft.Network'
$resourceTypeName = 'virtualNetworks'
$resourceGroupLocation = 'centralus'

$vNetName = 'vnet-contoso'
$vNetAddressPrefix = '172.16.0.0/16'
$vNetSubnet1Name = 'subnet-1'
$vNetSubnet1Prefix = '172.16.1.0/24'
$vNetSubnet2Name = 'subnet-2'
$vNetSubnet2Prefix = '172.16.2.0/24'

$randomString = ([char[]]([char]'a'..[char]'z') + 0..9 | Sort-Object {Get-Random})[0..8] -join ''
$storageAccountNamePrefix = 'storagehol'
$storageAccountType = 'Standard_LRS'
$storageAccountName = $storageAccountNamePrefix + ($storageAccountType.Replace('Standard_','')).ToLower() + $randomString
}

### Create Virtual Network Subnets
{
$vNetSubnet1 = New-AzureRmVirtualNetworkSubnetConfig `
    -Name $vNetSubnet1Name `
    -AddressPrefix $vNetSubnet1Prefix `
    -Verbose

$vNetSubnet2 = New-AzureRmVirtualNetworkSubnetConfig `
    -Name $vNetSubnet2Name `
    -AddressPrefix $vNetSubnet2Prefix `
    -Verbose
}

### Create Virtual Network
{
$vNet = New-AzureRmVirtualNetwork `
    -ResourceGroupName $resourceGroupName `
    -Location $resourceGroupLocation `
    -Name $vNetName `
    -AddressPrefix $vNetAddressPrefix `
    -Subnet $vNetSubnet1,$vNetSubnet2 `
    -Verbose -Force
}

### Create Storage Account
{
$storageAccount = New-AzureRmStorageAccount `
    -ResourceGroupName $resourceGroupName `
    -Location $resourceGroupLocation `
    -Name $storageAccountName `
    -Type $storageAccountType `
    -Verbose
}

### Section 2:
### =============================================
### This section includes commands to:
###  1 - Create a Service Plan
###  2 - Create a WebApp (App Service instance)
### =============================================
### Define Deployment Variables
{

$resourceGroupName = 'rg585563'
$resourceProviderNamespace = 'Microsoft.Web'
$resourceTypeName = 'sites'
$resourceGroupLocation = 'centralus'

$randomString = ([char[]]([char]'a'..[char]'z') + 0..9 | Sort-Object {Get-Random})[0..8] -join ''
$appNamePrefix = 'contoso'
$appServicePlanName = $appNamePrefix + $randomString
$webAppName = $appNamePrefix + $randomString

}

### Create App Service Plan
{

$appServicePlan = New-AzureRmAppServicePlan `
    -ResourceGroupName $resourceGroupName `
    -Location $resourceGroupLocation `
    -Name $appServicePlanName `
    -Tier Standard `
    -WorkerSize Small `
    -Verbose
}

### Create Web App
{

New-AzureRmWebApp `
    -ResourceGroupName $resourceGroupName `
    -Location $resourceGroupLocation `
    -AppServicePlan $appServicePlan.ServerFarmWithRichSkuName `
    -Name $webAppName `
    -Verbose
}
