# The user to chown files onto as they're created
HOST_UID=$(shell id -u ${USER})
# The local port to bind the Docker container onto
DOCKER_PORT=8443

# Under most circumstances, the following two variables should match your tlspretense.yaml file
# See Runbook: TLS Client Testing for more information
IPTABLES_DEST_IP=$(shell resolveip -s example.org)
IPTABLES_DEST_PORT=443

all: dev

clean:
	rm -f build_trusty_docker.built
	rm -rf ca
	rm -rf certs

build_trusty_docker.built:
	(docker build -t "tlspretense" .) && touch build_trusty_docker.built

certs: build_trusty_docker.built
	 docker run --privileged=true -i -t -v $(CURDIR)/ca:/default/ca -v $(CURDIR)/certs:/default/certs -e "UID=$(HOST_UID)" tlspretense /generate_certs.sh

run_trusty: certs
	docker run --privileged=true -i -t -p "0.0.0.0:$(DOCKER_PORT):$(DOCKER_PORT)" -v $(CURDIR)/ca:/default/ca -v $(CURDIR)/certs:/default/certs -e "DOCKER_PORT=${DOCKER_PORT}" -e "IPTABLES_DEST_IP=${IPTABLES_DEST_IP}" -e "IPTABLES_DEST_PORT=${IPTABLES_DEST_PORT}" tlspretense /run_tlspretense.sh

run_itrusty: certs
	docker run --privileged=true -i -t -p "0.0.0.0:$(DOCKER_PORT):$(DOCKER_PORT)" -v $(CURDIR)/ca:/default/ca -v $(CURDIR)/certs:/default/certs -e "DOCKER_PORT=${DOCKER_PORT}" -e "IPTABLES_DEST_IP=${IPTABLES_DEST_IP}" -e "IPTABLES_DEST_PORT=${IPTABLES_DEST_PORT}" tlspretense /bin/bash

dev: run_trusty

interactive: run_itrusty
