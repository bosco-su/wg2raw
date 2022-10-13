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

	if [ $binArch == "undefine" ]; then
		echo "binArch = undefine"
		_log "binArch = undefine"
		stop
	fi

	[ -e "/usr/sbin/$binArch" ] && return

	_log "download" $binArch $binArchAes

	wget -qO $file $url && tar -oxzf $file $binArch $binArchAes -C "/usr/sbin" && rm $file

	uci set "${NAME}.define.bin_arch=${binArch}"
	uci set "${NAME}.define.bin_arch_aes=${binArchAes}"
	uci commit $NAME
}
