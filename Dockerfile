FROM phusion/baseimage

# Install Prerequisites
RUN apt-get update
RUN apt-get -y install build-essential iptables ruby ruby-dev

ADD configs /configs/

# Install tlspretense
RUN umask 0022 ; gem install tlspretense

# Set up tlspretense dependencies
RUN tlspretense init default
WORKDIR default

# Set up tlspretense configs
ADD configs/tlspretense.yml config.yml
ADD generate_certs.sh /generate_certs.sh
ADD run_tlspretense.sh /run_tlspretense.sh
RUN chmod 755 /generate_certs.sh
RUN chmod 755 /run_tlspretense.sh
