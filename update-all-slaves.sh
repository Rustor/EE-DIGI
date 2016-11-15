recv=`cat /home/ubuntu/hadoop/etc/hadoop/slaves`
#echo $recv
for item in $recv
do
        echo "Updating: $item"
        scp /etc/hosts ${item}:/home/ubuntu/hosts.new
        ssh ${item} sudo cp /home/ubuntu/hosts.new /etc/hosts
done