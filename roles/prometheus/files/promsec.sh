#!/bin/bash

USER="misho"

HASH_PASSWORD=$(sudo grep "^$USER:" /etc/shadow | cut -d: -f2)

bash -c "cat << EOF >> /etc/prometheus/sec.yaml
basic_auth_users:
  $USER: $HASH_PASSWORD
EOF"

chown prometheus:prometheus /etc/prometheus/sec.yaml
