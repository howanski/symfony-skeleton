#!/bin/bash
clear
source .env
if [ ! -f "caddy/key.pem" ]; then
    echo "We need to generate TLS keys first - creating generic self-signed certificate"
    openssl req -x509 -newkey rsa:4096 -keyout caddy/key.pem -out caddy/cert.pem -days 3650 -subj "/C=$SSL_CERT_SELF_SIGNED_COUNTRY/ST=$SSL_CERT_SELF_SIGNED_STATE/L=$SSL_CERT_SELF_SIGNED_CITY/CN=$SSL_CERT_SELF_SIGNED_WWW_ADDRESS" -nodes
fi

mkdir -p postgres_data
mkdir -p ide_data/dot_config
mkdir -p ide_data/dot_local

# touch caddy/caddy.log

docker compose up
