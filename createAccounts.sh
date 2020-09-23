#!/bin/bash

# az account list [--output table]
SUBSCRIPTION="MCT STUDENT"

# az group list [--output table]
RESOURCE_GROUP="CloudServices"

az account set --subscription "$SUBSCRIPTION"

# Space delimited array
# Export from Leho "Cijferboek" 
USERS=""

# Create users
for USER in $USERS; do
    echo "Creating account for ${USER}"
    az role assignment create --role Owner --assignee "$USER" --resource-group "$RESOURCE_GROUP" --output tsv
done