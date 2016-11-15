#!/bin/bash
# copyright rto, dk
# Update and install basics
sudo apt-get update
sudo apt-get install -y default-jdk
sudo apt-get install -y ssh unzip netcat
ssh-keygen -f $HOME/.ssh/id_rsa -t rsa -N '' #ssh-keygen -t rsa -P ""
cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys
ssh-keyscan -H localhost >> ~/.ssh/known_hosts ## avoid interaction wrt known_hosts

## Down cluster forming helper scripts
wget https://raw.githubusercontent.com/Rustor/EE-DIGI/master/auto-slave.sh
wget https://raw.githubusercontent.com/Rustor/EE-DIGI/master/auto-slave-arg.sh
wget https://raw.githubusercontent.com/Rustor/EE-DIGI/master/auto-config.sh

# install Hadoop 
wget http://mirrors.dotsrc.org/apache/hadoop/common/hadoop-2.7.2/hadoop-2.7.2.tar.gz
tar zxf hadoop-2.7.2.tar.gz
ln -s hadoop-2.7.2 hadoop
cd hadoop
sudo -- sh -c -e  "echo '`hostname -i` fe1' >> /etc/hosts" # setup up this node as master=fe1.

# download EE-digi configuration files and configure hadoop
wget https://raw.githubusercontent.com/Rustor/EE-DIGI/master/EEDigi-hadoop-config.zip
unzip EEDigi-hadoop-config.zip
cp EEDigi-hadoop-config/* etc/hadoop/
echo  "export JAVA_HOME=/usr/lib/jvm/java-7-openjdk-amd64" >> etc/hadoop/hadoop-env.sh
bin/hadoop namenode -format



## ----------------------------
## install R and rmr2
##--------------------------

codename=$(lsb_release -c -s)
echo "deb http://cran.fhcrc.org/bin/linux/ubuntu $codename/" | sudo tee -a /etc/apt/sources.list > /dev/null
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9
sudo add-apt-repository -y ppa:marutter/rdev
sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y r-base

## install R hadoop dependencies
sudo Rscript -e 'install.packages( c("Rcpp","RJSONIO","bitops","digest","functional","reshape2","stringr","plyr","caTools") ,  repos="http://lib.ugent.be/CRAN/")'

## Install R hadoop itself
wget https://github.com/RevolutionAnalytics/rmr2/releases/download/3.3.1/rmr2_3.3.1.tar.gz
sudo R CMD INSTALL rmr2_3.3.1.tar.gz



