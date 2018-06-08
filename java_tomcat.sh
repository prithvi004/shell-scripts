sudo yum install java-1.8.0-openjdk.x86_64 \n
y\n
java -version

##Add Tomcat User
sudo groupadd tomcat
sudo mkdir /opt/tomcat
sudo useradd -s /bin/nologin -g tomcat -d /opt/tomcat tomcat

##Install Wget
sudo yum install wget
y\n

###Download tomcat
wget http://www-us.apache.org/dist/tomcat/tomcat-8/v8.0.52/bin/apache-tomcat-8.0.52.tar.gz
sudo tar -zxvf apache-tomcat-8.0.52.tar.gz -C /opt/tomcat --strip-components=1

###Before you can run Apache Tomcat, you need to setup proper permissions for several directories:
cd /opt/tomcat
sudo chgrp -R tomcat conf
sudo chmod g+rwx conf
sudo chmod g+r conf/*
sudo chown -R tomcat logs/ temp/ webapps/ work/
sudo chgrp -R tomcat bin
sudo chgrp -R tomcat lib
sudo chmod g+rwx bin
sudo chmod g+r bin/*

###Setup a Systemd unit file for Apache Tomcat

file="/etc/systemd/system/tomcat.service"
echo [Unit] > $file
echo Description=Apache Tomcat Web Application Container > $file
echo After=syslog.target network.target > $file
echo  > $file
echo [Service] > $file
echo Type=forking > $file
echo  > $file
echo Environment=JAVA_HOME=/usr/lib/jvm/jre > $file
echo Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid > $file
echo Environment=CATALINA_HOME=/opt/tomcat > $file
echo Environment=CATALINA_BASE=/opt/tomcat > $file
echo Environment='CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC' > $file
echo Environment='JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom' > $file
echo  > $file
echo ExecStart=/opt/tomcat/bin/startup.sh > $file
echo ExecStop=/bin/kill -15 $MAINPID > $file
echo  > $file
echo User=tomcat > $file
echo Group=tomcat > $file
echo  > $file
echo [Install] > $file
echo WantedBy=multi-user.target > $file

cat $file

###start tomcat
sudo systemctl start tomcat.service