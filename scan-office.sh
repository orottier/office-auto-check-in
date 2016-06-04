#!/bin/bash

source env.sh

# people who have been sent a message, flushed daily
touch pinged.out

# scan network
sudo nmap -sP 192.168.1.* > nmap.out

# checked in slack users
wget --quiet -O- $usersEndpoint | jq '.[] | select(.atOffice) | .slack' | sed 's/"//g' > checked-in.out

function slack {
	escapedText=$(echo $1 | sed 's/"/\"/g' | sed "s/'/\'/g" | sed 's/+/%2b/g' )
	json="{\"channel\": \"@$2\", \"text\": \"$escapedText\", \"username\": \"AMSBot\", \"icon_emoji\": \":ghost:\"}"
	curl -s -d "payload=$json" $slackEndpoint
}

function checkUser {
	echo Checking $1 for $2
	if grep -q "$1" nmap.out; then
		echo $2 " is in the office"
		if ! grep -q "^$2$" checked-in.out; then
			echo $2 " is not checked in"
			if ! grep -q "^$2$" pinged.out; then
				echo $2 " is not pinged yet"
				echo $2 >> pinged.out
				result=$(curl --silent --data "user_name=$2" $checkEndpoint)
				slack "Welcome to the office! $result" $2
			fi
		fi
	fi
}

while read line; do
	checkUser $line
done < users.list
