#!/bin/bash

scriptpath=/usr/bin/check_net
hotplugpath=/etc/hotplug.d/iface/10-checknet

realrun="$1"

if [ "$0" == "sh" ] || [ "$0" == "bash" ]; then
    realrun=""
fi

sScriptName="$(basename $scriptpath)"

checkrunning() {
	count="$1"
	logger "CheckNet: checking running of ${sScriptName}, count $count"
	if [ $(ps | grep ${sScriptName} | grep -v grep | wc -l) -gt $count ]; then
	    logger "CheckNet: already running exit"
	    exit
	fi
}

realrun() {
	checkrunning 3
	logger "CheckNet: script started"
	. /lib/functions/network.sh

	network_get_ipaddr lan_addr lan

	if [ "$lan_addr" == "" ]; then
		logger "CheckNet: no lan address yet, exit"
		return
	fi

	fail_count=0
	while :; do
	  sleep 2s

	  # try to connect
	  if ping -W 1 -c 1 "$lan_addr" >/dev/null 2>&1; then
	    # No problem!
	    if [ $fail_count -gt 0 ]; then
	      logger 'CheckNet: Network problems solved!'
	      return
	    fi
	    fail_count=0
	    logger 'CheckNet: No Problem, exit'
	    return
	  fi

	  # May have some problem
	  logger "CheckNet: Network may have some problems!"
	  fail_count=$((fail_count + 1))

	  if [ $fail_count -ge 3 ]; then
	    # Must have some problem! We refresh the ip address and try again!
	    network_get_ipaddr lan_addr lan

	    if ping -W 1 -c 1 "$lan_addr" >/dev/null 2>&1; then
	      return
	    fi

	    logger 'CheckNet: Network problem! Firewall reloading...'
	    /etc/init.d/firewall reload >/dev/null 2>&1
	    sleep 2s

	    if ping -W 1 -c 1 "$lan_addr" >/dev/null 2>&1; then
	      return
	    fi

	    logger 'CheckNet: Network problem! Network reloading...'
	    /etc/init.d/network restart >/dev/null 2>&1
	    sleep 2s
	  fi
	done
}

adduci() {
	if [ "$(basename $0)" == "$sScriptName" ]; then
	    pp=$(ps | grep $PPID | grep -v grep | awk '{print $5}')
	    if [ "$pp" == "fw3" ]; then
	    	logger 'CheckNet: running in fw3, ignore uci'
	    	return
	    fi
	    logger "CheckNet: checking uci"
		uci get firewall.checknet >/dev/null 2>&1
		if [ $? -ne 0 ]; then
			logger 'CheckNet: add uci firewall script'
			uci -q batch <<-EOF >/dev/null
			    set firewall.checknet=include
			    set firewall.checknet.type=script
			    set firewall.checknet.reload='1'
			    set firewall.checknet.path=$scriptpath
			    commit firewall
			EOF
		fi
	fi
}

addhotplug() {
	if ! [ -f "$hotplugpath" ]; then
		cat <<< "#!/bin/sh
$(echo $scriptpath)">"$hotplugpath"
		chmod +x "$hotplugpath"
	fi
}

if [ "$realrun" == "" ]; then
	checkrunning 2
	adduci
	addhotplug
	logger 'CheckNet: delay check 30 secs'
	(sleep 30 && $scriptpath realrun)&
else
	realrun
fi
