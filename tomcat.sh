amazon-linux-extras install java-openjdk11 -y
wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.109/bin/apache-tomcat-9.0.109.tar.gz
tar -zxvf apache-tomcat-9.0.109.tar.gz
sed -i '56  a\<role rolename="manager-gui"/>' apache-tomcat-9.0.109/conf/tomcat-users.xml
sed -i '57  a\<role rolename="manager-script"/>' apache-tomcat-9.0.109/conf/tomcat-users.xml
sed -i '58  a\<user username="tomcat" password="admin@123" roles="manager-gui, manager-script"/>' apache-tomcat-9.0.109/conf/tomcat-users.xml
sed -i '59  a\</tomcat-users>' apache-tomcat-9.0.109/conf/tomcat-users.xml
sed -i '56d' apache-tomcat-9.0.109/conf/tomcat-users.xml
sed -i '21d' apache-tomcat-9.0.109/webapps/manager/META-INF/context.xml
sed -i '22d'  apache-tomcat-9.0.109/webapps/manager/META-INF/context.xml
sh apache-tomcat-9.0.109/bin/startup.sh


#!/bin/bash

# 1️⃣ Install Amazon Corretto 17
sudo amazon-linux-extras enable corretto17 -y
sudo yum install -y java-17-amazon-corretto-devel wget tar

# 2️⃣ Download and extract Tomcat 9
wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.109/bin/apache-tomcat-9.0.109.tar.gz
tar -zxvf apache-tomcat-9.0.109.tar.gz

# 3️⃣ Configure Tomcat manager user
sed -i '56  a\<role rolename="manager-gui"/>' apache-tomcat-9.0.109/conf/tomcat-users.xml
sed -i '57  a\<role rolename="manager-script"/>' apache-tomcat-9.0.109/conf/tomcat-users.xml
sed -i '58  a\<user username="tomcat" password="admin@123" roles="manager-gui, manager-script"/>' apache-tomcat-9.0.109/conf/tomcat-users.xml
sed -i '59  a\</tomcat-users>' apache-tomcat-9.0.109/conf/tomcat-users.xml
sed -i '56d' apache-tomcat-9.0.109/conf/tomcat-users.xml

# 4️⃣ Update manager context to allow access
sed -i '21,22d' apache-tomcat-9.0.109/webapps/manager/META-INF/context.xml

# 5️⃣ Set Java 17 environment
export JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto
export PATH=$JAVA_HOME/bin:$PATH

# 6️⃣ Start Tomcat
sh apache-tomcat-9.0.109/bin/startup.sh

# 7️⃣ Verify Tomcat is running
echo "Tomcat started. Access manager at http://<EC2-IP>:8080/manager/html"
