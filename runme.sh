#!/bin/bash
set -e

###############################################################################
# Func:   get_value
# Note:   Get value from ini file
# Input:  path_to_config key_name
# Output: value of key
###############################################################################
function get_value() {
  local CFG  # path  to config file
  local KEY  # Key name
  CFG="$1"
  KEY="$2"
  tr -d " \t" < "${CFG}"| grep "^${KEY}=" | cut -f 2 -d "=" | tr -d "\n\r\""
}

###############################################################################
###############################################################################
# script location
CURPATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# terraform plan location
PLAN_DIR="${CURPATH}/envs/gce"

# google cloud access key location
KEY_PATH="/home/vagrant/.key.json"

# path to directory with PKI
PKI_DIR="/home/vagrant"

# Default openvpn client name
USER_NAME='lev'

# Project ID in google cloud
PROJECT_ID=$(get_value "${PLAN_DIR}/config_secrets.tfvars" "project")

# Your domain name, it uses for PKI
DOMAIN_NAME=$(get_value "${PLAN_DIR}/config_secrets.tfvars" "openvpn_cn")

# Billing ID in google cloud
BILLING_ID=$(get_value "${PLAN_DIR}/config_secrets.tfvars" "google_billing_id")

# Service account login name in google cloud
SERVICE_ACCOUNT='terraform'

# IAM email address in google cloud
IAM="${SERVICE_ACCOUNT}@${PROJECT_ID}.iam.gserviceaccount.com"

# color for log_message function
GREEN='\033[0;32m'
NC='\033[0m'
YELLOW='\033[0;33m'

###############################################################################
###############################################################################


###############################################################################
# Func:   log_message
# Note:   Print colored message to stdout
# Input:  [--wait] [--text some_text] [--color color]
# Output: --
###############################################################################
function log_message() {
  local l_wait
  local l_color
  local l_text

  l_color=$GREEN

  while [ "$1" != "" ] ; do
    case "$1" in
      --wait) l_wait="yes";;
      --text) l_text="$2"; shift ;;
      --color) l_color="$2"; shift ;;
    esac
    shift
  done

  echo -e "$(date +"%Y-%m-%d %H:%M:%S"): ${l_color}${l_text}${NC}"

  if [[ "${l_wait}" = "yes" ]] ; then
    echo -e "$(date +"%Y-%m-%d %H:%M:%S"): ${GREEN}Press enter to continue ${NC}"
    read -r
  fi
}

###############################################################################
# Func:   usage
# Note:   Print help to stdout
# Input:  --
# Output: --
###############################################################################
usage () {
  echo ""
  echo "Usage: $0 [-g] [-a] [-k] [-o] [-t] [-d] [-u user_name] [-h]"
  echo ""
  echo "-g|--gcloud-init       - Initialize access google via gcloud"
  echo "-a|--create-account    - Create google service account"
  echo "-k|--get-google-key    - Create key for service account & download it"
  echo "-o|--openvpn-init      - Initialize PKI"
  echo "-c|--openvpn-config    - Generate openvpn client config"
  echo "-t|--terraform-apply   - Initialize terraform & apply configuration"
  echo "-d|--terraform-destroy - Destroy configuration"
  echo "-r|--remove            - Cleanup VM: remove local state, google auth"
  echo "-u|--user              - Set openvpn client name"
  echo "-h|--help              - print this help"
  echo ""
  echo "Example:"
  echo "/vagrant/runme.sh --gcloud-init --terraform-apply --openvpn-init --openvpn-config --get-google-key"
  echo ""
  echo "Note: script read settings from terraform config <PLAN_DIR>/config_secrets.tfvars:"
  echo "${PLAN_DIR}/config_secrets.tfvars"
  echo ""
}

###############################################################################
# Func:   gcloud_get_key
# Note:   Create key for service account & download it
# Input:  IAM PATH_TO_CONFIG
# Output: --
###############################################################################
gcloud_get_key () {
  local IAM
  local SECRET_KEY_PATH
  IAM="$1"
  SECRET_KEY_PATH="$2"

  log_message --text "Create keys for '${IAM}'"
  log_message --wait --color "${YELLOW}" --text \
    "gcloud iam service-accounts keys create \
      --iam-account \"${IAM}\" \
      \"${SECRET_KEY_PATH}\""
  gcloud iam service-accounts keys create \
    --iam-account "${IAM}" \
    "${SECRET_KEY_PATH}"

  log_message --text "Set env var for accessing google"
  log_message --wait --color "${YELLOW}" --text \
    "export GOOGLE_APPLICATION_CREDENTIALS=\"${SECRET_KEY_PATH}\""
  export GOOGLE_APPLICATION_CREDENTIALS="${SECRET_KEY_PATH}"
}

###############################################################################
# Func:   gcloud_new_account
# Note:   Create google service account
# Input:  project_id service_account_name IAM
# Output: --
###############################################################################
gcloud_new_account () {
  local PROJECT_NAME
  local SERVICE_ACCOUNT
  local IAM

  PROJECT_NAME="$1"
  SERVICE_ACCOUNT="$2"
  IAM="$3"

  log_message --text "Create service account '${SERVICE_ACCOUNT}'"
  log_message --wait --color "${YELLOW}" --text \
    "gcloud iam service-accounts create \"${SERVICE_ACCOUNT}\""

  gcloud iam service-accounts create "${SERVICE_ACCOUNT}"

  log_message --text "Grant owner permissions for '${IAM}' to '${PROJECT_NAME}'"
  log_message --wait --color "${YELLOW}" --text \
    "cloud projects add-iam-policy-binding \"${PROJECT_NAME}\" \
      --member \"serviceAccount:${IAM}\" \
      --role roles/owner"

  gcloud projects add-iam-policy-binding "${PROJECT_NAME}" \
    --member "serviceAccount:${IAM}" \
    --role roles/owner
}

###############################################################################
# Func:   gcloud_init
# Note:   Initialize access google via gcloud
# Input:  project_id billing_id
# Output: --
###############################################################################
gcloud_init () {
  local PROJECT_NAME
  local BILLING_ID

  PROJECT_NAME="$1"
  BILLING_ID="$2"

  log_message --text \
    "Initialize project '${PROJECT_NAME}' in Google Cloud Platform"
  log_message --wait --color "${YELLOW}" --text \
    "gcloud init --project \"${PROJECT_NAME}\""
  gcloud init --project "${PROJECT_NAME}"

  log_message --text \
    "Link billing account '${BILLING_ID}' with project '${PROJECT_NAME}'"
  gcloud projects list
  gcloud alpha billing accounts list
  log_message --wait --color "${YELLOW}" --text \
    "gcloud alpha billing projects link \"${PROJECT_NAME}\" \
      --billing-account \"${BILLING_ID}\""

  gcloud alpha billing projects link "${PROJECT_NAME}" \
    --billing-account "${BILLING_ID}"

  log_message --text "Enable API"
  log_message --color "${YELLOW}" --text \
    "gcloud services enable container.googleapis.com"
  log_message --color "${YELLOW}" --text \
    "gcloud services enable storage-api.googleapis.com"
  log_message --color "${YELLOW}" --text \
    "gcloud services enable storage-component.googleapis.com"
  log_message --wait --color "${YELLOW}" --text \
    "gcloud services enable serviceusage.googleapis.com"

  gcloud services enable serviceusage.googleapis.com
  gcloud services enable container.googleapis.com
  gcloud services enable storage-api.googleapis.com
  gcloud services enable storage-component.googleapis.com
}

###############################################################################
# Func:   terraform_run
# Note:   Initialize terraform & apply configuration
# Input:  plan_dir
# Output: --
###############################################################################
terraform_run () {
  local PLAN_DIR
  PLAN_DIR="$1"

  log_message --text "Initialize terraform in '${PLAN_DIR}'"
  log_message --wait --color "${YELLOW}" --text \
    "terraform init \"${PLAN_DIR}\""
  terraform init "${PLAN_DIR}"

  log_message --text "Create terraform plan"
  log_message --wait --color "${YELLOW}" --text \
    "terraform plan \
      -var-file=\"${PLAN_DIR}/config_secrets.tfvars\" \
      \"${PLAN_DIR}\""
  terraform plan \
    -var-file="${PLAN_DIR}/config_secrets.tfvars" \
    "${PLAN_DIR}"

  log_message --text "Apply terraform plan"
  log_message --wait --color "${YELLOW}" --text \
    "terraform apply \
      -var-file=\"${PLAN_DIR}/config_secrets.tfvars\" \
      \"${PLAN_DIR}\""
  terraform apply \
    -var-file="${PLAN_DIR}/config_secrets.tfvars" \
    "${PLAN_DIR}"
}

###############################################################################
# Func:   terraform_destroy
# Note:   Destroy infrastructure
# Input:  plan_dir
# Output: --
###############################################################################
terraform_destroy () {
  local PLAN_DIR
  PLAN_DIR="$1"

  log_message --text "Destroy infrastructure"
  log_message --wait --color "${YELLOW}" --text \
    "terraform destroy  \
      -var-file=\"${PLAN_DIR}/config_secrets.tfvars\" \
      \"${PLAN_DIR}\""
  terraform destroy  \
    -var-file="${PLAN_DIR}/config_secrets.tfvars" \
    "${PLAN_DIR}"
}

###############################################################################
# Func:   openvpn_initpki
# Note:   Initialize PKI. Create certs & store in $OPENVPN_DIR/pki
# Input:  path_to_pki your_domain_name
# Output: --
###############################################################################
openvpn_initpki () {
  local OPENVPN_DIR
  local OPENVPN_HOST
  OPENVPN_DIR="$1"
  OPENVPN_HOST="$2"

  log_message --text "Initialize your PKI infrastructure"
  log_message --wait --color "${YELLOW}" --text \
    "docker run --user=\"$(id -u)\" \
      -e OVPN_SERVER_URL=\"tcp://${OPENVPN_HOST}:443\" \
      -v \"${OPENVPN_DIR}\":/etc/openvpn:z \
      -ti ptlange/openvpn ovpn_initpki"
  docker run --user="$(id -u)" \
    -e OVPN_SERVER_URL="tcp://${OPENVPN_HOST}:443" \
    -v "${OPENVPN_DIR}":/etc/openvpn:z \
    -ti ptlange/openvpn ovpn_initpki

  log_message --text \
    "Generate the initial Certificate Revocation List.\
    This file needs to be updated every 180 days."
  log_message --wait --color "${YELLOW}" --text \
    "docker run --user=\"$(id -u)\" \
      -e EASYRSA_CRL_DAYS=180 \
      -v \"${OPENVPN_DIR}\":/etc/openvpn:z \
      -ti ptlange/openvpn easyrsa gen-crl"
  docker run --user="$(id -u)" \
    -e EASYRSA_CRL_DAYS=180 \
    -v "${OPENVPN_DIR}":/etc/openvpn:z \
    -ti ptlange/openvpn easyrsa gen-crl
}

###############################################################################
# Func:   openvpn_getclient
# Note:   Generate openvpn client config
# Input:  path_to_pki client_name openvpn_server_host openvpn_server_port
# Output: --
###############################################################################
openvpn_getclient () {
  local OPENVPN_DIR
  local OPENVPN_USER
  local OPENVPN_HOST
  local OPENVPN_PORT
  local OVPN_CLIENT_PROXY
  OPENVPN_DIR="$1"
  OPENVPN_USER="$2"
  OPENVPN_HOST="$3"
  OPENVPN_PORT="$4"
  OVPN_CLIENT_PROXY="$(echo $http_proxy|cut -f3 -d/|cut -f1 -d: )"

  log_message --text "Generate client key"
  log_message --wait --color "${YELLOW}" --text \
    "docker run --user=\"$(id -u)\" \
      -v \"${OPENVPN_DIR}\":/etc/openvpn:z \
      -ti ptlange/openvpn \
      easyrsa build-client-full \"${OPENVPN_USER}\" nopass"
  docker run --user="$(id -u)" \
    -v "${OPENVPN_DIR}":/etc/openvpn:z \
    -ti ptlange/openvpn \
    easyrsa build-client-full "${OPENVPN_USER}" nopass

  log_message --text "Generate client openvpn config"
  log_message --wait --color "${YELLOW}" --text \
    "docker run --user=\"$(id -u)\" \
      -e OVPN_ADDR=\"${OPENVPN_HOST}\" \
      -e OVPN_PORT=\"${OPENVPN_PORT}\" \
      -e OVPN_PROTO=\"tcp\" \
      -e OVPN_CLIENT_PROXY=\"${OVPN_CLIENT_PROXY}\" \
      -v \"${OPENVPN_DIR}\":/etc/openvpn:z \
      --rm ultral/openvpn \
      ovpn_getclient \"${OPENVPN_USER}\" > \"${OPENVPN_USER}.ovpn\""
  docker run --user="$(id -u)" \
    -e OVPN_ADDR="${OPENVPN_HOST}" \
    -e OVPN_PORT="${OPENVPN_PORT}" \
    -e OVPN_PROTO="tcp" \
    -e OVPN_CLIENT_PROXY="${OVPN_CLIENT_PROXY}" \
    -v "${OPENVPN_DIR}":/etc/openvpn:z \
    --rm ultral/openvpn \
    ovpn_getclient "${OPENVPN_USER}" > "${OPENVPN_USER}.ovpn"

  log_message --text "Config saved as ${OPENVPN_USER}.ovpn"
}

###############################################################################
# Func:   cleanup
# Note:   Cleanup VM: remove local state, google auth
# Input:  plan_dir pki_dir
# Output: --
###############################################################################
function cleanup() {
  local PLAN_DIR
  local OPENVPN_DIR
  local IAM
  PLAN_DIR="$1"
  OPENVPN_DIR="$2"
  IAM="$3"

  log_message --wait --text "Cleanup ALL"

  gsutil rb gs://gcp-adm_tfstate/ || log_message --wait --text "ERR bucket"
  gcloud iam service-accounts delete "${IAM}" || log_message --wait --text "ERR iam"

  gcloud services disable serviceusage.googleapis.com || log_message --wait --text "ERR srv"
  gcloud services disable container.googleapis.com || log_message --wait --text "ERR gke"
  gcloud services disable storage-api.googleapis.com || log_message --wait --text "ERR api"
  gcloud services disable storage-component.googleapis.com || log_message --wait --text "ERR str"

  log_message --text "Cleanup files"
  rm -rvf ~/.key.json
  rm -rvf .terraform*
  rm -rvf terraform.tfstate
  rm -rvf ~/.gcloud/
  rm -rvf ~/.config/gcloud/
  rm -rvf "${OPENVPN_DIR}/pki/"
  rm -rvf "${OPENVPN_DIR}/*.ovpn"
}
###############################################################################
#
# Parse script params
#
###############################################################################
while [ "$1" != "" ] ; do
  case "$1" in
    -g|--gcloud-init) GCLOUD_INIT='YES' ;;
    -a|--create-account) GCLOUD_NEW_ACCOUNT='YES' ;;
    -k|--get-google-key) GCLOUD_GET_KEY='YES' ;;
    -o|--openvpn-init) OPENVPN_INIT='YES' ;;
    -c|--openvpn-config) OPENVPN_CONFIG='YES' ;;
    -t|--terraform-apply) TERRAFORM_APPLY='YES' ;;
    -d|--terraform-destroy) TERRAFORM_DESTROY='YES' ;;
    -r|--remove) CLEANUP='YES' ;;
    -u|--user) USER_NAME="$2" ; shift ;;
    -h|--help) usage ;;
  esac
  shift
done

###############################################################################
#
# Run script functions
#
###############################################################################

[[ "${CLEANUP}" = "YES" ]] && \
  cleanup "${PLAN_DIR}" "${PKI_DIR}" "${IAM}"

[[ "${GCLOUD_INIT}" = "YES" ]] && \
  gcloud_init "${PROJECT_ID}" "${BILLING_ID}"

[[ "${GCLOUD_NEW_ACCOUNT}" = "YES" ]] && \
  gcloud_new_account "${PROJECT_ID}" "${SERVICE_ACCOUNT}" "${IAM}"

[[ "${GCLOUD_GET_KEY}" = "YES" ]] && \
  gcloud_get_key "${IAM}" "${KEY_PATH}"

[[ "${OPENVPN_INIT}" = "YES" ]] && \
  openvpn_initpki "${PKI_DIR}" "${DOMAIN_NAME}"

[[ "${TERRAFORM_APPLY}" = "YES" ]] && \
  terraform_run "${PLAN_DIR}"

[[ "${TERRAFORM_DESTROY}" = "YES" ]] && \
  terraform_destroy "${PLAN_DIR}"

if [[ "${OPENVPN_CONFIG}" = "YES" ]] ; then
  VPN_ADDR=$(terraform output vpn_server_addr)
  VPN_PORT=$(terraform output vpn_server_port)
  openvpn_getclient "${PKI_DIR}" "${USER_NAME}" "${VPN_ADDR}" "${VPN_PORT}"
fi

exit 0
