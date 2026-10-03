#!/bin/sh
IFACE=$(ip -o -4 route show to default | awk '{print $5}' | head -n1)
echo "%{F#2495e7}󰈀 %{F#ffffff}$(/usr/sbin/ifconfig $IFACE 2>/dev/null | grep 'inet ' | awk '{print $2}')%{u-}"
