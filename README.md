# gcemanage

VM for managing VPN in GCE

# justdoit
```
$ vagrant up
$ vagrant ssh
$ /vagrant/runme.sh --gcloud-init --terraform-apply --openvpn-init
```

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


# Credits
I used code from zambien's and kylemanna's openvpn repos in this work:
[pieterlange/kube-openvpn](https://github.com/pieterlange/kube-openvpn)
[zambien/terraform-gcp-gke-openvpn](https://github.com/zambien/terraform-gcp-gke-openvpn)

## FIX
```
$ docker build --build-arg http_proxy=$http_proxy --build-arg https_proxy=$http_proxy --no-cache  -t ultral/openvpn .
$ gcloud container clusters get-credentials gce4vpn-k8s --zone europe-north1-a

$ kubectl get pods

#standard_init_linux.go:190: exec user process caused "no such file or directory"


```
