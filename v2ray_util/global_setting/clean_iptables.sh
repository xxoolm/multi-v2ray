#!/bin/bash
clean_old_iptables(){
    local TYPE=$1
    if [[ $NETWORK == 1 ]];then
        RESULT=$(ip6tables -nvL $TYPE --line-number|grep state|awk -F ':' '{print $2"  " $1}'|awk '{print $2" "$1}'|sort -n -k1 -r)
    else
        RESULT=$(iptables -nvL $TYPE --line-number|grep state|awk -F ':' '{print $2"  " $1}'|awk '{print $2" "$1}'|sort -n -k1 -r)
    fi
    echo "$RESULT" | while read LINE
    do
        LINE_ARRAY=($LINE)
        if [[ ${LINE_ARRAY[1]} && $(lsof -i:${LINE_ARRAY[1]}|grep v2ray) ]];then
            [[ $NETWORK == 1 ]] && ip6tables -D $TYPE ${LINE_ARRAY[0]} || iptables -D $TYPE ${LINE_ARRAY[0]}
        fi
    done
}

clean_iptables(){
    local TYPE=$1
    if [[ $NETWORK == 1 ]];then
        RESULT=$(ip6tables -nvL $TYPE --line-number|grep :|awk -F ':' '{print $2"  " $1}'|awk '{print $2" "$1}'|sort -n -k1 -r)
    else
        RESULT=$(iptables -nvL $TYPE --line-number|grep :|awk -F ':' '{print $2"  " $1}'|awk '{print $2" "$1}'|sort -n -k1 -r)
    fi
    echo "$RESULT" | while read LINE
    do
        LINE_ARRAY=($LINE)
        if [[ ${LINE_ARRAY[1]} && -z $(lsof -i:${LINE_ARRAY[1]}) ]];then
            [[ $NETWORK == 1 ]] && ip6tables -D $TYPE ${LINE_ARRAY[0]} || iptables -D $TYPE ${LINE_ARRAY[0]}
        fi
    done
}

clean_old_iptables INPUT
clean_iptables INPUT
clean_iptables OUTPUT