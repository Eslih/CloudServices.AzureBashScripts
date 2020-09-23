#!/bin/bash

TAG="student"

RESOURCE_NAMES=$(az resource list --query "[?!(contains(to_string(tags), '$TAG'))].{ name: name, type: type }" --output json | jq -c '.[]')
RESOURCE_GROUP="CloudServices"
SUBSCRIPTION="MCT STUDENT"

az account set --subscription "$SUBSCRIPTION"

for RESOURCE_NAME in $RESOURCE_NAMES; do
  echo "Deleting $RESOURCE_NAME ..."
  az resource delete \
    --name "$(echo "$RESOURCE_NAME" | jq -r '.name')" \
    --resource-type "$(echo "$RESOURCE_NAME" | jq -r '.type')" \
    --resource-group "$RESOURCE_GROUP"
done
