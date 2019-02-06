D := docker

OS_TYPE := $(shell uname)
PYTHONPATH := $(shell pwd):$$PYTHONPATH
BUILD_ID ?= $(shell uuidgen | head -c 8)

DOCKER_USER ?=
DOCKER_PASS_BASE64 ?=

DOCKER_REPO := pkprzekwas/flask-app
ifeq ($(OS_TYPE), Darwin)
	DOCKER_PASS_DECODED := $(shell echo $(DOCKER_PASS) | base64 -D)
else
	DOCKER_PASS_DECODED := $(shell echo $(DOCKER_PASS) | base64 -d)
endif

clean-pyc:
	@find . -name '*.pyc' -exec rm -rf {} +
	@find . -name '*.pyo' -exec rm -rf {} +

docker-login:
	@docker login -u $(DOCKER_USER) -p $(DOCKER_PASS_DECODED)

docker-build: clean-pyc
	@$(D) build -t $(DOCKER_REPO) .
	@$(D) tag $(DOCKER_REPO):latest $(DOCKER_REPO):$(BUILD_ID)

docker-publish: docker-login docker-build
	@$(D) push $(DOCKER_REPO):latest
	@$(D) push $(DOCKER_REPO):$(BUILD_ID)

test:
	@$(D) run -it --rm $(DOCKER_REPO) pytest

lint:
	@$(D) run -it --rm $(DOCKER_REPO) flake8 .

jenkins-build-image:
	@$(D) build -t jenkins:local ./jenkins

jenkins-run: build-jenkins
	@$(D) run -d -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins:local

minikube-start:
	@./scripts/minikube_start.sh

print-my-ip-addr:
ifeq ($(OS_TYPE), Darwin)
	HOST_IP=$(shell ifconfig | grep "inet " | grep -Fv 127.0.0.1 | awk '{print $$2}' | head -1)
else
	HOST_IP=$(shell hostname -I | cut -d \ -f 1 )
endif
