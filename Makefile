OS_TYPE := $(shell uname)

#	https://github.com/jenkinsci/docker/blob/master/README.md
build-jenkins:
	docker build -t jenkins:local ./jenkins

run-jenkins: build-jenkins
	docker run -d -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins:local

minikube-start:
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


print-my-ip-addr:
ifeq ($(OS_TYPE), Darwin)
	HOST_IP=$(shell ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '{print $$2}' | head -1)
else
	HOST_IP=$(shell hostname -I | cut -d \ -f 1 )
endif
