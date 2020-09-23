#!/bin/bash

TAG="student"

RESOURCE_NAMES=$(az resource list --query "[?!(contains(to_string(tags), '$TAG'))].{ name: name }" -o tsv)


for RESOURCE_NAME in $RESOURCE_NAMES; do
  echo "Deleting $RESOURCE_NAME ..."
done