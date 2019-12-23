#/bin/bash

# Generate CA cert
openssl req -newkey rsa:4096 -keyform PEM -keyout ca.key -x509 -days 3650 -outform PEM -out ca.cer

# Generate Server Certification
openssl genrsa -out server.key 4096

openssl req -new -key server.key -out server.req -sha256

openssl x509 -req -in server.req -CA ca.cer -CAkey ca.key -set_serial 100 -extensions server -days 1460 -outform PEM -out server.cer -sha256

rm server.req

# Configure Apache to use certs
cp ca.cer /etc/ssl/certs/

cp server.cer /etc/ssl/certs/server.crt
cp server.key /etc/ssl/private/server.key
a2enmod ssl

a2ensite default-ssl
a2dissite default
SSLCACertificateFile /etc/ssl/certs/ca.cer
SSLCertificateFile    /etc/ssl/certs/server.crt
SSLCertificateKeyFile /etc/ssl/private/server.key

service apache2 restart

# Generate Client Certification
openssl genrsa -out client.key 4096
openssl req -new -key client.key -out client.req

openssl x509 -req -in client.req -CA ca.cer -CAkey ca.key -set_serial 101 -extensions client -days 365 -outform PEM -out client.cer

openssl pkcs12 -export -inkey client.key -in client.cer -out client.p12
rm client.key client.cer client.req