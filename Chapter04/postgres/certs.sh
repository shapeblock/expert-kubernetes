#!/bin/bash
set -euo pipefail

kubectl delete csr --ignore-not-found 'stackgres-operator'
cat << EOF > /tmp/csr.conf
[req]
req_extensions = v3_req
distinguished_name = req_distinguished_name
[req_distinguished_name]
[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names
[alt_names]
DNS.1 = stackgres-operator
DNS.2 = stackgres-operator.stackgres
DNS.3 = stackgres-operator.stackgres.svc
DNS.4 = stackgres-operator.stackgres.svc.cluster.local
EOF


#  openssl req -new -nodes -text -keyout /tmp/root.key \
#      -subj "/CN=system:node:stackgres-operator.stackgres;/O=system:nodes" \
#      -out /tmp/server.csr \
#      -config /tmp/csr.conf
openssl req -new -nodes -text -keyout /tmp/root.key \
    -subj "/CN=stackgres-operator.stackgres" \
    -out /tmp/server.csr \
    -config /tmp/csr.conf
openssl rsa -in /tmp/root.key -pubout -out /tmp/root.pem

# certificates.k8s.io/v1beta1
cat << EOF | kubectl create -f -
apiVersion: certificates.k8s.io/v1
kind: CertificateSigningRequest
metadata:
  name: stackgres-operator
spec:
  request: "$(cat /tmp/server.csr | base64 | tr -d '\n')"
  usages:
  - digital signature
  - key encipherment
  - server auth
  signerName: beta.eks.amazonaws.com/app-serving
EOF

if ! kubectl get csr 'stackgres-operator' -o yaml|grep -q '^    type: Approved$'
then
  kubectl certificate approve 'stackgres-operator'
  echo -n "Waiting for CSR approval..."
  until kubectl get csr 'stackgres-operator' -o yaml|grep -q '^    type: Approved$'
  do
    echo -n .
    sleep 5
  done
  echo "approved"
fi
echo -n "Waiting for CSR certificate generation..."
until kubectl get csr 'stackgres-operator' \
  --template '{{ if .status }}{{ if .status.certificate }}true{{ end }}{{ end }}' \
  | grep -q '^true$'
do
  echo -n .
  sleep 5
done
echo "certificate generated"

KEY="$(cat /tmp/root.key | base64 | tr -d '\n')"
PUB="$(cat /tmp/root.pem | base64 | tr -d '\n')"
CRT="$(kubectl get csr 'stackgres-operator' --template '{{ .status.certificate }}')"

if [ -z "$CRT" ]
then
  echo "Certificate not found in CSR!"
  exit 1
fi
echo $CRT | base64 --decode > /tmp/root.crt

kubectl delete csr --ignore-not-found 'stackgres-operator'

