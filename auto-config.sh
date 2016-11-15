rm cluster-config.file
touch cluster-config.file
while [ 1 ] ;
do
cat /home/ubuntu/.ssh/id_rsa.pub  2>&1| netcat -l 54321 >> cluster-config.file
sort cluster-config.file | uniq > temp-config.file #remove dublet lines
rm cluster-config.file
cp temp-config.file cluster-config.file
echo "."
done