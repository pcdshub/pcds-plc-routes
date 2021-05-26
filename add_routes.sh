#!/bin/bash

HUTCH=$1
PLC_MATCH=${2}

if [[ -z "${HUTCH}" || -z "${PLC_MATCH}" ]]; then
    echo "Usage: $0 hutch plc-hostname-match"
    echo "Notes:"
    echo "* ioc_hosts/{hutch}.txt should exist"
    echo "* plc-hostname-match will be sent to 'netconfig'"
    exit 0
fi

if [ ! -f "ioc_hosts/${HUTCH}.txt" ]; then
    echo "Error: file not found ioc_hosts/${HUTCH}.txt"
    exit 1
fi

IOC_HOSTS=$(cat ioc_hosts/${HUTCH}.txt)
PLCS=$(netconfig search ${PLC_MATCH} --brief | sort | tr '\r\n' ' ')

echo "Found PLCs: $PLCS"

for ioc_host in $IOC_HOSTS; do
    ioc_host_ip=$(dig +short ${ioc_host}.pcdsn)
    ioc_host_net_id="${ioc_host_ip}.1.1"
    echo ""
    echo "* IOC host: $ioc_host ($ioc_host_ip) Net ID: ${ioc_host_net_id}"

    ssh $ioc_host <<EOF
        source /reg/g/pcds/pyps/conda/pcds_conda
        conda activate /cds/home/k/klauer/miniforge3/envs/py38
        set -x
        for plc in $PLCS; do
            ads-async route --route-name="${ioc_host}" \${plc} ${ioc_host_net_id} ${ioc_host_ip};
        done
EOF

done
