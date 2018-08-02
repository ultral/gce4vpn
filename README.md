# gcemanage

VM for managing VPN in GCE

# justdoit
```
$ vagrant up
$ vagrant ssh

$ docker run --user=$(id -u) -e OVPN_SERVER_URL=tcp://vpn.goncharov.xyz:1194 -v $PWD:/etc/openvpn:z -ti ptlange/openvpn ovpn_initpki
$ docker run --user=$(id -u) -e EASYRSA_CRL_DAYS=180 -v $PWD:/etc/openvpn:z -ti ptlange/openvpn easyrsa gen-crl

$ runme.sh --gcloud-init --terraform-apply --project-id gce4vpn6

$ docker run --user=$(id -u) -v $PWD:/etc/openvpn:z -ti ptlange/openvpn easyrsa build-client-full lev nopass
$ docker run --user=$(id -u) -e OVPN_SERVER_URL=tcp://vpn.goncharov.xyz:1194 -v $PWD:/etc/openvpn:z --rm ptlange/openvpn ovpn_getclient lev > lev.ovpn

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
[pieterlange/kube-openvpn](https://github.com/pieterlange/kube-openvpn)
[terraform-gcp-gke-openvpn]https://github.com/zambien/terraform-gcp-gke-openvpn

## FIX
```
$ gcloud container clusters get-credentials gce4vpn-k8s --zone europe-north1-a

$ kubectl get pods

$ gcloud container clusters describe gce4vpn-k8s --zone europe-north1-a| grep servicesIpv4Cidr
servicesIpv4Cidr: 10.55.240.0/20

$ gcloud container clusters describe gce4vpn-k8s --zone europe-north1-a | grep clusterIpv4Cidr
clusterIpv4Cidr: 10.52.0.0/14
```
