#!/bin/bash

# --------------------------------------------
# generate-wildcard-cert.sh
# Creates a wildcard self-signed cert (*.domain)
# Outputs to ./certs directory
# --------------------------------------------

set -e

# Prompt user for the domain name
read -rp "Enter your domain (e.g. example.com): " DOMAIN

# Validate input
if [[ -z "$DOMAIN" ]]; then
  echo "❌ Domain cannot be empty."
  exit 1
fi

CERT_DIR="$(dirname "$0")/certs"
CERT_PATH="$CERT_DIR/cert.pem"
KEY_PATH="$CERT_DIR/key.pem"

# Create certs directory if it doesn't exist
mkdir -p "$CERT_DIR"

# Generate a private key and self-signed wildcard certificate
openssl req -x509 -nodes -newkey rsa:2048 \
  -keyout "$KEY_PATH" \
  -out "$CERT_PATH" \
  -days 365 \
  -subj "/C=US/ST=Local/L=Lab/O=HomeLab/OU=IT/CN=*.$DOMAIN" \
  -addext "subjectAltName=DNS:*.$DOMAIN,DNS:$DOMAIN"

echo ""
echo "✅ Wildcard self-signed certificate generated for *.$DOMAIN"
echo " - Certificate: $CERT_PATH"
echo " - Key:         $KEY_PATH"
