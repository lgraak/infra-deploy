#!/bin/bash

echo "=== Proxmox Template Builder ==="

STOR="proxmox-vmstore"

NODES=("mustafar" "tython" "endor")
echo "Choose Proxmox node:"
select NODE in "${NODES[@]}"; do
  [[ -n "$NODE" ]] && break
done

DISTROS=("ubuntu" "debian")
echo "Choose Distro:"
select DISTRO in "${DISTROS[@]}"; do
  [[ -n "$DISTRO" ]] && break
done

if [[ "$DISTRO" == "ubuntu" ]]; then
  VERSIONS=("22.04" "24.04")
elif [[ "$DISTRO" == "debian" ]]; then
  VERSIONS=("12")
fi

echo "Choose Version:"
select VERSION in "${VERSIONS[@]}"; do
  [[ -n "$VERSION" ]] && break
done

DEFAULT_NAME="${DISTRO}-${VERSION}-template"
read -rp "Template name [default: $DEFAULT_NAME]: " NAME
NAME="${NAME:-$DEFAULT_NAME}"

read -rp "VM ID: " VMID
read -rp "RAM (MB): " RAM
read -rp "CPU cores: " CPU
read -rp "Disk size (GB): " DISK
read -rp "Cloud-init username: " CIUSER
read -rp "Password: " CIPASS
read -rp "VLAN tag (optional): " VLAN

# Define image URL
if [[ $DISTRO == "ubuntu" ]]; then
  BASE_URL="https://cloud-images.ubuntu.com/releases/${VERSION}/release/"
  FILENAME="ubuntu-${VERSION}-server-cloudimg-amd64.img"
elif [[ $DISTRO == "debian" ]]; then
  CODE=""
  [[ "$VERSION" == "12" ]] && CODE="bookworm"
  [[ "$VERSION" == "13" ]] && CODE="trixie"
  BASE_URL="https://cloud.debian.org/images/cloud/${CODE}/latest/"
  FILENAME="debian-${VERSION}-genericcloud-amd64.qcow2"
else
  echo "Unsupported distro"
  exit 1
fi

/opt/ansible-venv/bin/ansible-playbook -i localhost, playbooks/create-template.yml \
  --extra-vars "target_node=$NODE template_name=$NAME vmid=$VMID base_url=$BASE_URL filename=$FILENAME ram=$RAM cpu=$CPU disk=$DISK vlan_tag=$VLAN ciuser=$CIUSER cipassword=$CIPASS proxmox_storage=$STOR"
