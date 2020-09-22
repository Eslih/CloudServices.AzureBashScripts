#!/bin/bash

# az account list [--output table]
SUBSCRIPTION="MCT STUDENT"

# az group list [--output table]
RESOURCE_GROUP="CloudServices"
STATE="VM running"
NAME="esli"

START="$(date +%s)"

az account set --subscription "$SUBSCRIPTION"

VM_NAMES=$(az vm list --resource-group "$RESOURCE_GROUP" --show-details --query "[?powerState=='$STATE' && contains(name, '$NAME')].{ name: name }" -o tsv)

for VM_NAME in $VM_NAMES; do
  echo "Deallocating $VM_NAME ..."
  az vm deallocate --name "$VM_NAME" --resource-group $RESOURCE_GROUP --no-wait
done

STOP="$(date +%s)"

DURATION=$((STOP - START))

printf 'Elapsed time: %02dh:%02dm:%02ds\n' $((DURATION / 3600)) $((DURATION % 3600 / 60)) $((DURATION % 60))
