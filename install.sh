#!/bin/bash

set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

RDP_PORT=3390

echo -e "${YELLOW}Updating packages...${NC}"
apt update && apt upgrade -y

echo -e "${YELLOW}Installing GNOME Flashback and XRDP...${NC}"
DEBIAN_FRONTEND=noninteractive apt install -y gnome-session-flashback xrdp mesa-utils

echo -e "${YELLOW}Configuring XRDP to use GNOME Flashback (metacity)...${NC}"
echo "gnome-session --session=gnome-flashback-metacity" > /etc/xrdp/startwm.sh
chmod +x /etc/xrdp/startwm.sh

echo -e "${YELLOW}Setting RDP to static port ${RDP_PORT}...${NC}"
sed -i "s/port=3389/port=${RDP_PORT}/g" /etc/xrdp/xrdp.ini

echo -e "${YELLOW}Enabling and restarting XRDP...${NC}"
systemctl enable xrdp
systemctl restart xrdp

echo -e "${YELLOW}Fetching public IP address...${NC}"
PUBLIC_IP=$(curl -s ifconfig.me || curl -s ipinfo.io/ip || echo "Unavailable")

echo -e "${GREEN}✅ GNOME + XRDP installed and running!${NC}"
echo -e "${GREEN}RDP Address: ${YELLOW}${PUBLIC_IP}:${RDP_PORT}${NC}"
