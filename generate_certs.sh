#!/bin/sh
tlspretense ca
tlspretense certs
chown ${UID} -R ca certs
