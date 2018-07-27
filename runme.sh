#!/bin/bash
set -e

PROJECT_ID='gce4vpn'
BUCKET_NAME="${PROJECT_ID}_terraform-remote-states"

usage () {
  echo "Usage: $0 [--gcloud-init] [--terraform-apply] [--help] [--project-id <some-name>]"
  echo ""
}

gcloud_setup () {
  local PROJECT_NAME
  local BILLING_ID
  local BUCKET_NAME
  PROJECT_NAME="$1"
  BUCKET_NAME="$2"

  gcloud init --project "${PROJECT_NAME}"
  echo "${PROJECT_NAME}" > envs/gce/.project.name
  echo
  echo !!!!!!!!!!!!!!!!!!!!!!!
  echo
  echo Please visit: https://console.developers.google.com/ and save key as 'envs/gce/.key.json'
  echo https://console.developers.google.com/
  echo
  echo !!!!!!!!!!!!!!!!!!!!!!!
  echo
  echo After that press Enter
  read

  BILLING_ID=$(gcloud alpha billing accounts list |grep True|head -n1|cut -f1 -d" ")
  echo "Please check your billing ID '${BILLING_ID}'"
  echo After that press Enter
  read

  gcloud alpha billing projects link "${PROJECT_NAME}" --billing-account "${BILLING_ID}"
  gcloud services enable container.googleapis.com
  gcloud services enable storage-api.googleapis.com
  gcloud services enable storage-component.googleapis.com
  gsutil mb -p "${PROJECT_NAME}" "gs://${BUCKET_NAME}/"
}

terraform_run () {
  local PROJECT_NAME
  local BUCKET_NAME
  local PLAN_DIR
  local GOOGLE_CREDS
  PROJECT_NAME="$1"
  BUCKET_NAME="$2"
  PLAN_DIR="envs/gce/"
  GOOGLE_CREDS=$(cat "${PLAN_DIR}/.key.json")

  pushd .
  cd "${PLAN_DIR}"
  GOOGLE_CREDENTIALS="${GOOGLE_CREDS}" terraform init \
    -backend-config="project=${PROJECT_NAME}" \
    -backend-config="bucket=${BUCKET_NAME}"
  GOOGLE_CREDENTIALS="${GOOGLE_CREDS}" terraform apply
  popd
}

while [ "$1" != "" ] ; do
  case "$1" in
    -g|--gcloud-init) GCLOUD_INIT='YES' ;;
    -t|--terraform-apply) TERRAFORM_APPLY='YES' ;;
    -p|--project-id) PROJECT_ID="$2" ; shift ;;
    -h|--help) usage ;;
  esac
  shift
done

[ -z "${GCLOUD_INIT}" ] && GCLOUD_INIT='NO'
[ -z "${TERRAFORM_APPLY}" ] && TERRAFORM_APPLY='NO'

[ "_${GCLOUD_INIT}" = "_YES" ] && gcloud_setup "${PROJECT_ID}" "${BUCKET_NAME}"
[ "_${TERRAFORM_APPLY}" = "_YES" ] && terraform_run "${PROJECT_ID}" "${BUCKET_NAME}"
