Scan the local network and check in whoever is there

You'll need
 - a machine connected to the local office network to run this
 - to configure a Slack incoming webhook
 - some sort of people check in system in place
 
Server requirements:
 - nmap
 - jq

Setup by copying and modifying
 - env.sh.example -> env.sh
 - users.list.example -> users.list

Put in your crontab
```
*/5 * * * * cd /path/to/directory; ./scan-office.sh
0   3 * * * rm -f /path/to/directory/pinged.out
```

Enjoy!
