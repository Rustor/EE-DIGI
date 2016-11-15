## aws start script ## aws cleans auth.keys on cloning

#!/bin/bash

# sudo -- sh -c -e  "echo '172.31.26.253 fe1' >> /etc/hosts" # not required for normal setup procedure. since master ip is already known

echo "`hostname -i`   `hostname`" > mystring

count=0
while ((  count < 30 )) ;
do
cat mystring | nc fe1 54321 > authorized_keys
#cat authorized_keys >> /home/ubuntu/.ssh/authorized_keys# not required for normal setup procedure
sleep 30s
((count++))
echo "$count"
# clean up .ssh/authorized_keys
# cat .ssh/authorized_keys | uniq > uniq.temp; # not required for normal setup procedure
# cp uniq.temp  .ssh/authorized_keys
done
