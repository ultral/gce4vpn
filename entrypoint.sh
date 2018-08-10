#!/bin/bash

set -ae

if [ ! -d "${EASYRSA_PKI}" ]; then
    echo "PKI directory missing. Did you mount in your Secret?"
    exit 1
fi

OVPN_PORT="${OVPN_PORT:-1194}"
OVPN_NETWORK="${OVPN_NETWORK:-10.140.0.0 255.255.255.0}"
OVPN_PROTO="${OVPN_PROTO:-tcp}"
OVPN_NATDEVICE="${OVPN_NATDEVICE:-eth0}"
OVPN_VERB=${OVPN_VERB:-3}

envsubst < $OVPN_TEMPLATE > $OVPN_CONFIG

iptables -t nat -A POSTROUTING -o ${OVPN_NATDEVICE} -j MASQUERADE

mkdir -p /dev/net
if [ ! -c /dev/net/tun ]; then
    mknod /dev/net/tun c 10 200
fi

echo "$(date "+%a %b %d %H:%M:%S %Y") Running 'openvpn ${ARGS[@]} ${USER_ARGS[@]}'"
exec openvpn --config $OVPN_CONFIG 1> /dev/stderr 2> /dev/stderr
