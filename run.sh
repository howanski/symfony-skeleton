#!/bin/bash
clear
if [ ! -f "caddy/key.pem" ]; then
    echo "We need to generate TLS keys first"
    openssl req -x509 -newkey rsa:4096 -keyout caddy/key.pem -out caddy/cert.pem -days 3650 -nodes
fi

# touch caddy/caddy.log

docker compose up
