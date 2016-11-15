## aws start script ## aws cleans auth.keys on cloning

#!/bin/bash
masterip=${1}
#masterip="1.1.1.1"
sudo -- sh -c -e  "echo '${masterip} fe1' >> /etc/hosts"
echo "`hostname -i`   `hostname`" > mystring

count=0
while ((  count < 30 )) ;
do
cat mystring | nc fe1 54321 > authorized_keys
cat authorized_keys >> /home/ubuntu/.ssh/authorized_keys
sleep 30s
((count++))
echo "$count"
# clean up .ssh/authorized_keys
cat .ssh/authorized_keys | uniq > uniq.temp; cp uniq.temp  .ssh/authorized_keys
done
