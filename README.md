# gcemanage

VM for managing VPN in GCE

# Start

## Create VM
```
vagrant up
```

## Gcloud login
ssh to vm & run
```
gcloud init
```

## Get access key
* Go to https://console.developers.google.com/
* get access key
* save in repo as _.key.json_

## Enable k8s
If you want to use kubernetis, you have to enabe API & link billing account with your project

### Enable billing
* Get billing account ID
```
gcloud alpha billing accounts list
```
* Link you billing account with your project
```
gcloud alpha billing projects link my-project \
      --billing-account 0X0X0X-0X0X0X-0X0X0X
```

### Enable k8s
```
gcloud services enable container.googleapis.com
```

## Terraform
```
terraform init
terraform apply
```


gcloud container clusters get-credentials --zone europe-north1-a
