#!/bin/bash

export zbsmsuser=contoso.com
export zbsmspass=password
export zbsmssender="user"
export zbsmsbody="$3"
export zbsmsto="$1"
export zbsmslog="/your_log_location/SMS.log"
export mailto=example@contoso.com

date +"%r-%m-%d-%Y" | tr -d "\n" | sed 's/$/ /' >>$zbsmslog;

curl    --silent \
		--header "Content-Type: application/json" \
        --request POST \
        --data ' { "authentication": {"username": "'"$zbsmsuser"'", "password": "'"$zbsmspass"'"},
                "messages": [{"sender": "'"$zbsmssender"'", "type": "longSMS" ,"datacoding": "8","text": "'"$zbsmsbody"'",
                        "recipients": [{"gsm": "'"$zbsmsto"'"}]}]}'  \
        https://api.infobip.com/api/v3/sendsms/json | sed '1d'| tr --delete '\[\{\}\"\]' >>$zbsmslog 2>&1
		


ERR=$(cat $zbsmslog | tail -1 | grep -v "status:0");

 if [ -n "$ERR" ];
 then
 echo $ERR |tr -d \\r | mail -v -s "$HOSTNAME sms error" $mailto
 
 
fi
