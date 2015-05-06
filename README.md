# tlspretense-service
A Docker container that exposes tlspretense as a service. This launches [tlspretense](https://github.com/iSECPartners/tlspretense) in a Docker container, exposing its tests without having to use the container as a NAT device.

This project is very similar to [tlspretense-docker](https://github.com/wsargent/tlspretense-docker), except it allows clients to connect to the container directly (as if it were the target service) instead of updating their routing rules to go through it. This is very useful in environments in which invasive networking changes are not practical, but in which directing clients to a different service and port is easy.

Running tlspretense-service:

1. git clone this repository
2. Update the variables in its Makefile and configs/tlspretense.yml to meet your needs:

  - DOCKER_PORT will be the port the Docker container uses to accept new connections. You’ll be pointing your HTTPS client at this during testing.
  - IPTABLES_DEST_IP is the ipv4 address of a target service to proxy for.
  - IPTABLES_DEST_PORT is the port to talk to on the target service.
  
3. Update hostname in configs/tlspretense.yml to the one for your target service. This will be used for both lookup and masquerading.
You can test a local service or a remote one.
  - A local service (one on the same host as tlspretense-service) should have the same hostname and a different port. This is by far the simplest way to test your service, as all of the “goodca” test cases should succeed.
Remote services work a bit differently. Unless you set up your own firewall rules (eg, iptables NAT using MASQUERADE), the goodca tests will fail. Keep this in mind.
  - Update dest_port to reflect the port you've used in DOCKER_PORT as well. This is only necessary to ensure tlspretense is listening on the right port inside of the container, and will be unified with DOCKER_PORT in a later version.
4. make
5. Point your client at the host running your Docker container, along the port specified in DOCKER_PORT.

  - Your client should specifically use the CA certificates provided by tlspretense. For example, using curl: 
    curl --cacert tlspretense/ca/goodcacert.pem https://example.org:12345

  - Each request from your client will consume one test case in the container.
6. Repeat until all tests are exhausted
7. Once all tests have been exhausted, the container will print a report to console and terminate. Read the report printed by the container for which tests passed and failed, with a brief summary detailing the expected responses from your client.

To rerun all tests, simply issue make again. If you change any variables, be sure to issue a make clean beforehand, so the Docker container is rebuilt accordingly.
