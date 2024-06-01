#!/bin/bash

ROOT_CA_KEY_DIR="/root_ca/private"
ROOT_CA_CERT_DIR="/root_ca/certs"
SSL_KEY_DIR="/etc/ssl/private"
SSL_CERT_DIR="/etc/ssl/certs"

ROOT_CA_NAME="DevRootCA"
ROOT_CA_KEY="${ROOT_CA_KEY_DIR}/${ROOT_CA_NAME}.key"
ROOT_CA_CERT="${ROOT_CA_CERT_DIR}/${ROOT_CA_NAME}.pem"

SSL_CERT_NAME="DevopsAcademy"
SSL_SUBJECT="/C=GE/ST=Georgia/L=Tbilisi/O=academy/OU=devops/CN=grafana.devops.tbc"
SSL_KEY="${SSL_KEY_DIR}/${SSL_CERT_NAME}.key"
SSL_CSR="${SSL_CERT_DIR}/${SSL_CERT_NAME}.csr"
SSL_CERT="${SSL_CERT_DIR}/${SSL_CERT_NAME}.crt"

sudo mkdir -p "$ROOT_CA_KEY_DIR" "$ROOT_CA_CERT_DIR" "$SSL_KEY_DIR" "$SSL_CERT_DIR"

openssl genrsa -out "${ROOT_CA_KEY}" 2048

openssl req -x509 -new -nodes -key "${ROOT_CA_KEY}" -sha256 -days 1024 -out "${ROOT_CA_CERT}" -subj "/C=GE/ST=Georgia/L=Tbilisi/O=academy/OU=devops/CN=${ROOT_CA_NAME}"

openssl x509 -in "${ROOT_CA_CERT}" -text -noout

openssl req -new -nodes -out "${SSL_CSR}" -newkey rsa:2048 -keyout "${SSL_KEY}" -subj "${SSL_SUBJECT}"

openssl req -in "${SSL_CSR}" -text -noout

openssl x509 -req -in "${SSL_CSR}" -CA "${ROOT_CA_CERT}" -CAkey "${ROOT_CA_KEY}" -CAcreateserial -out "${SSL_CERT}" -days 365 -sha256

openssl x509 -in "${SSL_CERT}" -text -noout

openssl verify -CAfile "${ROOT_CA_CERT}" "${SSL_CERT}"

sudo cp "${ROOT_CA_CERT}" /usr/local/share/ca-certificates/DevRootCA.crt
sudo update-ca-certificates