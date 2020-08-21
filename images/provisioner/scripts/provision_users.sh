#!/bin/bash

set -euo pipefail

APN1=${APN1:-oai.ipv4}
APN2=${APN2:-internet}
KEY=${KEY:-8baf473f2f8fd09487cccbd7097c6862}
IMSI_FIRST=${IMSI_FIRST:-208950000000002}
MSISDN_FIRST=${IMSI_FIRST:-001011234561000}
MME_IDENTITY=${MME_IDENTITY:-oai-mme.local.net}
NUM_OF_USERS=${NUM_OF_USERS:-40}
REALM=${REALM:-local.net}
CASSANDRA_IP=${CASSANDRA_IP:-oai-cassandra}


/opt/oai-hss/bin/data_provisioning_users --apn $APN1 --apn2 $APN2 --key $KEY \
--imsi-first $IMSI_FIRST --msisdn-first $MSISDN_FIRST --mme-identity $MME_IDENTITY --no-of-users $NUM_OF_USERS \
--realm $REALM --truncate True  --verbose True --cassandra-cluster $CASSANDRA_IP

exec "$@"
