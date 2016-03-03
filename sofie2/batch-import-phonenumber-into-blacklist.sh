#!/bin/bash
cli="/usr/sbin/asterisk -rx"
dump=/tmp/blacklist.backup
blacklist=/tmp/blacklist_phonenumber.txt
 
curl http://localhost/test/blacklist_phonenumber.txt > $blacklist
 
echo "Dumping old blacklist to $dump"
$cli "database show blacklist" > $dump
 
if [ "$1" == "-d" ]; then
  echo "Removing all existing blacklist entries"
  $cli "database deltree blacklist"
fi
 
cat $blacklist | while read line; do
  [[ $line = \#* ]] && continue
  number=${line%;*}
  desc=${line#*;}
  echo "database put blacklist $number \"$desc\""
  $cli "database put blacklist $number \"$desc\""
done
