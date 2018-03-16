#!/bin/bash -eu

. "$(dirname $0)"/../../scripts/export-director-metadata

#bakup_time=$(date +"%F"-"%S")

backup-timestamp=$(date +"%Y-%m-%d-%S")
e=$?
pushd ../../../ert-backup-artifact <<EOF
  ../binary/bbr deployment --target "${BOSH_ADDRESS}" \
  --username "${BOSH_CLIENT}" \
  --deployment "${ERT_DEPLOYMENT_NAME}" \
  --ca-cert "${BOSH_CA_CERT_PATH}" \
  backup --with-manifest
  if [ "${e}" -ne "0"]; then
  	pushd ../../../ert-backup-artifact
  ../binary/bbr deployment --target "${BOSH_ADDRESS}" \
  --username "${BOSH_CLIENT}" \
  --deployment "${ERT_DEPLOYMENT_NAME}" \
  --ca-cert "${BOSH_CA_CERT_PATH}" \
  backup-cleanup
  fi
  pushd ../../../ert-backup-artifact
  ../binary/bbr deployment --target "${BOSH_ADDRESS}" \
  --username "${BOSH_CLIENT}" \
  --deployment "${ERT_DEPLOYMENT_NAME}" \
  --ca-cert "${BOSH_CA_CERT_PATH}" \
  backup --with-manifest
  tar -cvf ert-backup-$backup-timestamp.tar -- *
popd
EOF
