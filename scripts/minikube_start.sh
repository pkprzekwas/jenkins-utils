#!/usr/bin/env bash

minikube start \
	--vm-driver=virtualbox \
	--cpus 2 \
	--disk-size 20g \
	--memory 4096 \
	--network-plugin=cni \
	--kubernetes-version=v1.11.5
openssl pkcs12 -export \
	-out ~/.minikube/minikube.pfx \
	-inkey ~/.minikube/apiserver.key \
	-in ~/.minikube/apiserver.crt \
	-certfile ~/.minikube/ca.crt \
	-passout pass:secret
