#!/bin/bash

systemctl enable systemd-resolved.service

systemctl enable udp2raw-server.service
systemctl start udp2raw-server.service
systemctl status udp2raw-server.service
