#!/bin/sh
# Run this script ONCE to generate the self-signed certificate.
# The cert and key are committed to the repo for convenience in a lab environment.
# DO NOT do this in production — use Let's Encrypt or a real CA.
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout nginx/ssl/key.pem \
    -out    nginx/ssl/cert.pem \
    -subj   "/C=RU/ST=Moscow/L=Moscow/O=University/CN=localhost"

echo "Certificate generated:"
openssl x509 -in nginx/ssl/cert.pem -noout -text | grep -E 'Subject|Validity|Not'
