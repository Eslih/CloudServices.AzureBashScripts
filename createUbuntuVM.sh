#!/bin/bash

# How much VMs?
# Integer check ==>  Is >= 1 <= 5
if [[ "$1" =~ ^[0-9]+$ ]] && [ "$1" -ge 1 ] && [ "$1" -le 5 ]; then
  echo "$1 VMs will be created"
else
  echo "Wrong argument."
  exit 1
fi

# az account list [--output table]
SUBSCRIPTION="MCT STUDENT"

# az group list [--output table]
RESOURCE_GROUP="CloudServices"

# Set subscription
az account set --subscription "$SUBSCRIPTION"

# az vm image list -f Ubuntu [--all --output table]
# az vm image list -p canonical -o table --all | grep 20_04-lts | grep -v gen2
IMAGE_URN="Canonical:0001-com-ubuntu-server-focal:20_04-lts:latest"

# az account list-locations --output table
# az vm list-sizes -l westeurope --output table | grep B1s
VM_SIZE="Standard_B1s"
ADMIN_USERNAME="esli"
SSH_KEY="$HOME/.ssh/id_rsa.pub"
NETWORK_SECURITY_GROUP="UbuntuSecurityGroup"
NETWORK_SECURITY_RULE="AllowSSHHowest"
TAG="student=EsliHeyvaert"

# Subscriptie instellen, alle resources zullen dan sowieso onder deze subscription worden aangemaakt
#az account set --subscription $RESOURCE_GROUP

START="$(date +%s)"

# Create security group
echo "Creating security group (if not already exists)"
az network nsg create \
  --resource-group "$RESOURCE_GROUP" \
  --name "$NETWORK_SECURITY_GROUP" \
  --tags "$TAG" \
  --output table

# Create security rule
# Allow SSH from Howest (public) network
echo "Creating security group rule (if not already exists)"
az network nsg rule create \
  --resource-group "$RESOURCE_GROUP" \
  --nsg-name "$NETWORK_SECURITY_GROUP" \
  --name "$NETWORK_SECURITY_RULE" \
  --priority 100 \
  --access Allow \
  --destination-port-ranges 22 \
  --protocol Tcp \
  --source-address-prefixes 192.191.0.0/16 193.191.136.212 \
  --source-port-ranges '*' \
  --output table

# Create VMs
echo "Creating VMs"
for ((i = 1; i <= "$1"; i++)); do
  VM_NAME="ubuntu-esli-$(date +%s)"
  az vm create \
    --name "$VM_NAME" \
    --image "$IMAGE_URN" \
    --size "$VM_SIZE" \
    --resource-group "$RESOURCE_GROUP" \
    --ssh-key-value "$SSH_KEY" \
    --nsg "$NETWORK_SECURITY_GROUP" \
    --admin-user "$ADMIN_USERNAME" \
    --tags "$TAG" \
    --no-wait \
    --output table
done

STOP="$(date +%s)"

DURATION=$((STOP - START))

printf 'Elapsed time: %02dh:%02dm:%02ds\n' $(($DURATION / 3600)) $(($DURATION % 3600 / 60)) $(($DURATION % 60))
