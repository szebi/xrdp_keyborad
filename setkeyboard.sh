#!/bin/bash

# Script for setting the keyboard layout according to the xfconf + the current kbd layout settings.
#  Can be used standalone or sourced. 
#  Practically started from /etc/xrdp/startwm.sh and from Xsession.d 
#
# Environment: Ubuntu desktop width xfce4 
#  
# Parameters:
# arg1: time (sec) to wait before the action
#   default: 0
#     explanation: xrdp client sends the actual kbd layout code to the server, but according the 
#     protocol only one code, and it overrides the xface settings ~10-20 seconds later than 
#     the session manager or the /etc/drdp/reconnectwm.sh has been started.
#
# arg2: Full pathname of the log file. Ifit is "syslog", the syslog facility will be used. 
#   default: standard output
#
# Helpers for sourced usage:
# save_fd_12 - saves the stdout and stderr
# restore_fd_12 - restores the saved values 
#
# Athor: "Imre Szeberenyi" <szebi@iit.bme.hu>

#set -x

save_fd_12() {
    exec 11>&1
    exec 12>&2
}

restore_fd_12() {
    exec 1>&11 11>&-
    exec 2>&12 12>&-
}

setkeyboard() {
    local timo
    timo=$1
    : ${timo:=0}
    local logfile
    logfile=$2
    local logger
    logger=0
    if [ x"$logfile" = x"syslog" ]; then
        logger=1
        logfile=$(mktemp)
    fi
    if [ x"$logfile" != x ]; then exec > $logfile 2>&1; fi
    echo ${DBUS_SESSION_BUS_ADDRESS:="unix:path=/run/user/$UID/bus"}
    echo ${DISPLAY:=":10.0"}

    sleep $timo
    local client_layout
    client_layout=$(setxkbmap -query | sed -rn s'/layout:\s+(.{2}).*/\1/p')
    echo configured layout:
    xfconf-query -c keyboard-layout -lv
    local params
    params=($(xfconf-query -c keyboard-layout -lv | awk '
        BEGIN { out="'$client_layout'"; opt="" }
        /\/Default\/XkbLayout\s+/ { 
            split($2, a, ","); 
            for (i in a) 
                if (a[i] != "'$client_layout'") out = out","a[i]; print out
        }   

        /\/Default\/XkbOptions/ {
            if (opt == "") 
                opt = $2
            else
                opt = opt","$2
        }
        END { print out"\n"opt }
    '))
    local xconf_layout
    xconf_layout=${params[1]}
    local xconf_option
    xconf_option=${params[2]}
    local OPT
    if [ x$xconf_option != x ]; then OPT=-option; fi
    setxkbmap -option   # reset first 
    echo cmd: setxkbmap $OPT $xconf_option $xconf_layout
    setxkbmap $OPT $xconf_option $xconf_layout
    echo set values:
    setxkbmap -query

    if [ "$logger" = 1 ]; then
        # log to syslog 
        logger -t setkeyboard.sh -f $logfile
        rm -f $logfile
    fi
}

#if not sourced, call the function 
if [ x${BASH_SOURCE[0]} = x"$0" ]; then setkeyboard "$@"; fi


# vim:set ai et sts=4 sw=4 tw=80:
