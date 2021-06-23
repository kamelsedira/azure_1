#!/bin/bash

az cloud set --name AzureCloud
set MyResourceGroup=tp1-ksedira
set MySubscription=873000fa-a741-48e5-8ae7-41c7937c47c3
set MyVM=NginxNodeJS
 

# Creation du resources group 
# Verifie s'il exite deja, le crée dans le cas contraire
#az group list --output tsv | grep tp1-ksedira -q || az group create --location westus --ressource-group tp1-ksedira
#az group list --output tsv | grep $my-rg-name -q || az group create -l $regionName -n $my-rg-name
#az group create --location westus --subscription 873000fa-a741-48e5-8ae7-41c7937c47c3  --resource-group MyResourceGroup -g -n
az group create --location westus --subscription $MySubscription --resource-group MyResourceGroup -g -n


# Creation de la Machine Virtuelle et SSH keys si non present.
az vm create --resource-group $MyResourceGroup --name $MyVM --image UbuntuLTS --generate-ssh-keys
az vm create --resource-group tp1-ksedira --name tp1-ksediraVM1 --image UbuntuLTS --generate-ssh-keys

# Ouverture du port 80 
az vm open-port --port 80 --resource-group $MyResourceGroup --name $My-VMN 

# Installation par customScript extension de NGINX.
az vm extension set \
  --publisher Microsoft.Azure.Extensions \
  --version 2.0 \
  --name CustomScript \
  --vm-name $MyVM \
  --resource-group $MyResourceGroup \
  -- custom-data cloud-init.cfg
 # --settings '{"commandToExecute":"apt-get -y update && apt-get -y install nginx"}'

