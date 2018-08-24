#!/bin/bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

function log_message() {
  echo -e "$(date +"%Y-%m-%d %H:%M:%S"): ${GREEN} $* ${NC}"
}

function get_value() {
  local CONFIG_PATH
  local VALUE_NAME

  CONFIG_PATH="$1"
  VALUE_NAME="$2"
  tr -d " \t" < "${CONFIG_PATH}"| grep "^${VALUE_NAME}=" | cut -f 2 -d "=" | tr -d "\n\r\""
}

CURPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PLAN_DIR="${CURPATH}/envs/gce"
KEY_PATH="${PLAN_DIR}/.key.json"
OPENVPN_DIR="/home/vagrant"
USER_NAME='lev'
PROJECT_ID=$(get_value "${PLAN_DIR}/config_secrets.tfvars" "project")
DOMAIN_NAME=$(get_value "${PLAN_DIR}/config_secrets.tfvars" "openvpn_cn")
BILLING_ID=$(get_value "${PLAN_DIR}/config_secrets.tfvars" "google_billing_id")
IAM=$(get_value "${PLAN_DIR}/config_secrets.tfvars" "service_account")
#gcloud alpha billing accounts list |grep True|head -n1|cut -f1 -d" "

usage () {
  echo "Usage: $0 [--gcloud-init] [--terraform-apply] [--terraform-destroy] [--help]"
  echo ""
}

gcloud_setup () {
  local PROJECT_NAME
  local BILLING_ID
  local IAM
  local SERVICE_ACCOUNT
  local SECRET_KEY_PATH

  PROJECT_NAME="$1"
  BILLING_ID="$2"
  SERVICE_ACCOUNT="$3"
  SECRET_KEY_PATH="$4"
  IAM="${SERVICE_ACCOUNT}@${PROJECT_NAME}.iam.gserviceaccount.com"

  log_message "Init project: '${PROJECT_NAME}'"
  gcloud init --project "${PROJECT_NAME}"

  log_message "Link billig account '${BILLING_ID}' to project '${PROJECT_NAME}'"
  gcloud projects list
  gcloud alpha billing accounts list
  gcloud alpha billing projects link "${PROJECT_NAME}" --billing-account "${BILLING_ID}"

  log_message "Create service account '${SERVICE_ACCOUNT}'"
  gcloud iam service-accounts create "${SERVICE_ACCOUNT}"

  log_message "Create keys for '${IAM}'"
  gcloud iam service-accounts keys create \
    --iam-account "${IAM}" \
    "${SECRET_KEY_PATH}"

  log_message "Grant owner permissions for '${IAM}' to '${PROJECT_NAME}'"
  gcloud projects add-iam-policy-binding "${PROJECT_NAME}" \
    --member "serviceAccount:${IAM}" \
    --role roles/owner

  log_message "Enable API"
  gcloud services enable container.googleapis.com
  gcloud services enable serviceusage.googleapis.com
}

terraform_run () {
  local PLAN_DIR
  PLAN_DIR="$1"

  log_message "Run terraform from '${PLAN_DIR}'"

  terraform init "${PLAN_DIR}"
  terraform plan \
    -var-file="${PLAN_DIR}/config_secrets.tfvars" \
    "${PLAN_DIR}"
  terraform apply \
    -var-file="${PLAN_DIR}/config_secrets.tfvars" \
    "${PLAN_DIR}"
}

terraform_destroy () {
  local PLAN_DIR
  PLAN_DIR="$1"

  terraform destroy  \
    -var-file="${PLAN_DIR}/config_secrets.tfvars" \
    "${PLAN_DIR}"
}

openvpn_initpki () {
  local OPENVPN_DIR
  local OPENVPN_HOST
  OPENVPN_DIR="$1"
  OPENVPN_HOST="$2"

  docker run --user=$(id -u) \
    -e OVPN_SERVER_URL="tcp://${OPENVPN_HOST}:443" \
    -v $OPENVPN_DIR:/etc/openvpn:z \
    -ti ptlange/openvpn ovpn_initpki

  docker run --user=$(id -u) \
    -e EASYRSA_CRL_DAYS=180 \
    -v $OPENVPN_DIR:/etc/openvpn:z \
    -ti ptlange/openvpn easyrsa gen-crl
}

openvpn_getclient () {
  local OPENVPN_DIR
  local OPENVPN_USER
  local OPENVPN_HOST
  local OPENVPN_PORT
  OPENVPN_DIR="$1"
  OPENVPN_USER="$2"
  OPENVPN_HOST="$3"
  OPENVPN_PORT="$4"

  docker run --user=$(id -u) \
    -v $OPENVPN_DIR:/etc/openvpn:z \
    -ti ptlange/openvpn \
    easyrsa build-client-full ${OPENVPN_USER} nopass

  docker run --user=$(id -u) \
    -e OVPN_ADDR="${OPENVPN_HOST}" \
    -e OVPN_PORT="${OPENVPN_PORT}" \
    -e OVPN_PROTO="tcp" \
    -e OVPN_CLIENT_PROXY="$(echo $http_proxy|cut -f3 -d/|cut -f1 -d: )" \
    -v $OPENVPN_DIR:/etc/openvpn:z \
    --rm ultral/openvpn \
    ovpn_getclient ${OPENVPN_USER} > "${OPENVPN_USER}.ovpn"
}

while [ "$1" != "" ] ; do
  case "$1" in
    -g|--gcloud-init) GCLOUD_INIT='YES' ;;
    -o|--openvpn-init) OPENVPN_INIT='YES' ;;
    -c|--openvpn-config) OPENVPN_CONFIG='YES' ;;
    -t|--terraform-apply) TERRAFORM_APPLY='YES' ;;
    -d|--terraform-destroy) TERRAFORM_DESTROY='YES' ;;
    -u|--user) USER_NAME="$2" ; shift ;;
    -h|--help) usage ;;
  esac
  shift
done

[ -z "${GCLOUD_INIT}" ] && GCLOUD_INIT='NO'
[ -z "${OPENVPN_INIT}" ] && OPENVPN_INIT='NO'
[ -z "${TERRAFORM_APPLY}" ] && TERRAFORM_APPLY='NO'
[ -z "${TERRAFORM_DESTROY}" ] && TERRAFORM_DESTROY='NO'


[ "_${GCLOUD_INIT}" = "_YES" ] && gcloud_setup "${PROJECT_ID}" "${BILLING_ID}" "${IAM}" "${KEY_PATH}"
[ "_${OPENVPN_INIT}" = "_YES" ] && openvpn_initpki "${OPENVPN_DIR}" "${DOMAIN_NAME}"
[ "_${TERRAFORM_APPLY}" = "_YES" ] && terraform_run "${PLAN_DIR}"
[ "_${TERRAFORM_DESTROY}" = "_YES" ] && terraform_destroy "${PLAN_DIR}"

if [ "_${OPENVPN_CONFIG}" = "_YES" ] ; then
  VPN_ADDR=$(terraform output vpn_server_addr)
  VPN_PORT=$(terraform output vpn_server_port)
  openvpn_getclient "${OPENVPN_DIR}" "${USER_NAME}" "${VPN_ADDR}" "${VPN_PORT}"
fi
