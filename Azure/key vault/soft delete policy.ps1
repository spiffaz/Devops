# Define variables
$Subscription = "" # Subscription Name
$SoftDeleteRetentionDays = 90 # Number of days to keep your key vault recoverable from deletion
$LogFilePath = "" # Log path

# Set the Azure subscription
az account set --subscription $Subscription

# Get the list of Key Vaults
Add-Content -Path $LogFilePath "Getting the list of Key Vaults"
$KeyVaults = az keyvault list --subscription $Subscription --query "[].{name:name}" --output tsv
Add-Content -Path $LogFilePath "The available Key Vaults are: $KeyVaults"

foreach ($Vault in $KeyVaults) {
    # Get the resource group name for the Key Vault
    $GroupName = az keyvault list --subscription $Subscription --query "[?name=='$Vault'].{Group:resourceGroup}" --output tsv

    # Check if soft delete is enabled for the Key Vault
    $SoftDeleteStatus = az keyvault show --resource-group $GroupName --name $Vault --query "properties.enableSoftDelete" --output tsv

    # If soft delete is not enabled, enable it
    if ($SoftDeleteStatus -ne "true") {
        Add-Content -Path $LogFilePath "Soft delete is not enabled for $Vault. Going to enable it..."
        $EnableSoftDeleteOutput = az keyvault update --name $Vault --resource-group $GroupName --enable-soft-delete $true --retention-days $SoftDeleteRetentionDays
        $EnableSoftDeleteOutput | Out-File -FilePath $LogFilePath -Append
    }
}
