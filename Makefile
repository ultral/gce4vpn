PROJECT_NAME := $(if $(PROJECT_NAME),$(PROJECT_NAME),gce4vpn)

.PHONY: init terraform all

init:
	gcloud init --project $(PROJECT_NAME)
	@echo Please visit: https://console.developers.google.com/ and save key as 'envs/gce/.key.json'
	@echo After that press Enter
	@read
	@echo "Please check your billing ID '$$(gcloud alpha billing accounts list |grep True|head -n1|cut -f1 -d" ")'"
	@echo After that press Enter
	@read
	gcloud alpha billing projects link $(PROJECT_NAME) --billing-account $$(gcloud alpha billing accounts list |grep True|head -n1|cut -f1 -d" ")
	gcloud services enable container.googleapis.com

terraform:
	cd envs/gce/ ; terraform init
	cd envs/gce/ ; terraform apply

all: init terraform
	echo done
