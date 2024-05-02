export SUBSCRIPTION="" # Subscription Name
export SOFT_DELETE_RETENTION_DAYS=90 # Number of days to keep your key vault recoverable from deletion 

az account set --subscription "$SUBSCRIPTION"

KEY_VAULTS=$(az keyvault list --subscription "$SUBSCRIPTION" --query "[].{name:name}" -o tsv)
for VAULT in ${KEY_VAULTS[@]}
do
  GROUP_NAME=$(az keyvault list --subscription "$SUBSCRIPTION" --query "[?name=='$VAULT'].{Group:resourceGroup}" --output tsv)
  SOFT_DELETE_STATUS=$(az keyvault show --resource-group $GROUP_NAME --name $VAULT --query "properties.enableSoftDelete" -o tsv)
  if [ "$SOFT_DELETE_STATUS" != true ]; then
    echo "Soft delete is not enabled for $VAULT. Going to enable it..."
    az keyvault update --name $VAULT --resource-group $GROUP_NAME --enable-soft-delete true --retention-days $SOFT_DELETE_RETENTION_DAYS
  fi
done
