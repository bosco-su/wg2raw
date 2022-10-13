#!/bin/bash

_download() {
    local arch=$(uname -m)
    local file="/tmp/udp2raw.tar.gz"
    local url="https://github.com/wangyu-/udp2raw/releases/download/20200818.0/udp2raw_binaries.tar.gz"

    local binArch="undefine"
    local binArchAes="undefine"

    case $arch in
    "x86_64")
        binArch="udp2raw_amd64"
        binArchAes="udp2raw_amd64_hw_aes"
        ;;
    esac

    [[ $binArch == "undefine" ]] && {
        echo "Not currently supported $arch"
        exit 1
    }

    [[ -e "/usr/sbin/$binArch" ]] && {
        echo "Skip download"
        return
    }

    echo "Download: $binArch $binArchAes"
    wget -qO $file $url && tar -oxzf $file $binArch $binArchAes -C "/usr/sbin" && rm $file
}

_create_service() {
    local file="/etc/systemd/system/udp2raw-server.service"

    [[ -e $file ]] && {
        echo "Skip create service"
        return
    }

    echo "Create service: $file"
    cat >$file <<EOF
[Unit]
Description=upd2raw server daemon
After=syslog.target network.target auditd.service
Before=systemd-networkd.service
Wants=systemd-networkd.service

[Service]
Type=simple
EnvironmentFile=/etc/udp2raw/server
ExecStart=/usr/sbin/udp2raw_amd64_hw_aes -s \\
    -l \${tcp_listen} \\
    -r \${udp_listen} \\
    --key \${key} \\
    --raw-mode \${raw_mode} \\
    --cipher-mode \${cipher_mode} \\
    --auth-mode \${auth_mode} \\
    --auto-rule
ExecReload=/bin/kill -HUP
ExecStop=/bin/kill -s QUIT PrivateTmp=true
Restart=on-failure
RestartSec=10s

[Install]
WantedBy=multi-user.target
EOF
}

echo "Install..."
_download
_create_service
