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

        echo "download: $binArch $binArchAes"
        wget -qO $file $url && tar -oxzf $file $binArch $binArchAes -C "/usr/sbin" && rm $file
}

_create_service() {
	local file="/etc/systemd/system/udp2raw-server.service"
	
        [[ -e $file ]] && {
                echo "Skip create service"
                return
        }
	
	cat >$file<<-EOF  
	Hello,world!  
	EOF
}

echo "Install..."
_download
_create_service
