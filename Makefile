terraform:
	gcloud init
	echo Please visit: https://console.developers.google.com/ and save key as '.key.json'
	gcloud alpha billing accounts list
	gcloud services enable container.googleapis.com
	terraform init
	terraform apply
