#!/bin/bash

NOME=teste
VCPUS=1
RAM=1024
MAC=52:54:00:00:00:01
DEBIAN=buster

# Não alterar a partir daqui

virsh-install --name=${NOME} --vcpus=${VCPUS} --ram ${RAM} \
  --disk path=/vms/$NOME,bus=virtio,cache=none \
  --network bridge=virbr0,model=virtio,mac=$MAC --accelerate \
  --graphics none --extra-args="console=ttyS0,115200" \
  --location=http://deb.debian.org/debian/dists/$DEBIAN/main/installer-amd64
