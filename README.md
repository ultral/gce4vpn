# gce4vpn

This project was created just for luls: provision Openvpn inside kubernetes inside google cloud platform via terrafom. How ever it was used for [Hashicorp user group meetup](https://www.meetup.com/St-Petersburg-Russia-HashiCorp-User-Group/events/253644141/) & [chaos constructions](https://chaosconstructions.ru/) speeches. 

More related links locate [here](http://www.goncharov.xyz/gce4vpn.html)

# justdoit
```
$ vagrant up
$ vagrant ssh
$ /vagrant/runme.sh --gcloud-init --terraform-apply --openvpn-init --openvpn-config --get-google-key --create-account
```

# schema
![schema](schemas/schema.png?raw=true "Schema")

# Credits
I used code from zambien's and kylemanna's openvpn repos in this work:
[pieterlange/kube-openvpn](https://github.com/pieterlange/kube-openvpn)
[zambien/terraform-gcp-gke-openvpn](https://github.com/zambien/terraform-gcp-gke-openvpn)

## cheatsheet
```
$ docker build --build-arg http_proxy=$http_proxy --build-arg https_proxy=$http_proxy --no-cache  -t ultral/openvpn .
$ gcloud container clusters get-credentials gce4vpn-k8s --zone europe-north1-a
$ kubectl get pods
$ gcloud projects add-iam-policy-binding gcp-adm \
  --member="serviceAccount:terraform@gcp-adm.iam.gserviceaccount.com" \
  --role='roles/servicemanagement.admin'
$ gcloud projects get-iam-policy gcp-adm
$ sudo -E yum -y install graphviz && terraform  graph /vagrant/envs/gce/ | dot -Tsvg > graph.svg
```

## push state to remote
```
$ export GOOGLE_APPLICATION_CREDENTIALS=/home/vagrant/.key.json
$ echo 'terraform { backend "gcs" { bucket  = "gce4vpn31_tfstate" } }' > /vagrant/envs/gce/gcs.tf
$ cd /vagrant/envs/gce/ && terraform state push -force /home/vagrant/terraform.tfstate
$ terraform plan -var-file=./config_secrets.tfvars
```
