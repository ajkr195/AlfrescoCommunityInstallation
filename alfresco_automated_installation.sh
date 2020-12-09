#!/bin/bash

# THIS SCRIPT IS PRIMARILY INTENDED FOR UBUNTU MATE 20.04.1 (any may be other ubuntu based distros too). HOWEVER,
# THIS SCRIPT WORKS PERFECTYLY ON CentOS 7 TOO. Tested SUCCESSFULLY ON CentOS 7.9, Tomcat 8.5.60 AND POSTGRESQL-12.
# READ COMMENTS IN-LINE

# FOR EXAMPLE - alfrescohome=/home/admin/Documents/alfresco
alfrescohome=/home/<your_os_username>/Documents/alfresco62_0
alfrescodabasename=newalfdbname
dbownerusername=ownusername
dbowneruserpassword=ownpasswrod

if [ ! -d "$alfrescohome" ] ; then 
  echo -e "alf_home doest not exist...creating...$alfrescohome...";
  echo -e "Creating alf_home directory ...$alfrescohome...";
  mkdir "$alfrescohome";
  #sleep 3;
else
  echo -e "alf_home exists...$alfrescohome...";
  echo -e "Clearing alf_home for new installation...";
  rm -rf "$alfrescohome"/*
  #sleep 3;
fi

echo "Killing running processes at port 8080 if any..."
#pid=$(lsof -i:8080 -t); kill -TERM $pid || kill -KILL $pid
alias kill8080="fuser -k -n tcp 8080"
kill -9 $(lsof -i:8080 -t) 2> /dev/null
#sleep 3;
echo "Killing running processes at port 8191 if any..."
#pid2=$(lsof -i:8191 -t); kill -TERM $pid2 || kill -KILL $pid2
alias kill8191="fuser -k -n tcp 8191"
kill -9 $(lsof -i:8191 -t) 2> /dev/null
#sleep 3;
echo "Killing running processes at port 8983 if any..."
#pid3=$(lsof -i:8983 -t); kill -TERM $pid3 || kill -KILL $pid3
alias kill8983="fuser -k -n tcp 8983"
kill -9 $(lsof -i:8983 -t) 2> /dev/null
#sleep 3;


systemctl status postgresql > /dev/null
# WORKS PERFECTLY. COMMENT ABOVE AND UNCOMMENT BELOW IF USING POSTGRESQL 12 ON CentOS 7.
# systemctl status postgresql-12

if [ "$?" -gt "0" ]; then
  echo -e "PostgreSQL Database Not Installed..\nError..!!!\nExiting now..."
  exit 1; 
else
  echo -e "PostgreSQL is installed...Proceeding..."
fi

echo -e "Downloading required packages..."


if [ ! -f alfresco-content-services-community-distribution-6.2.0-ga.zip ] ; then 
    echo -e "Downloading ACS package...";
	wget -q https://download.alfresco.com/cloudfront/release/community/201911-GA-build-368/alfresco-content-services-community-distribution-6.2.0-ga.zip ; 
else
  echo -e "ACS package already exists...skipping...";
fi
if [ ! -f alfresco-search-services-1.4.0.zip ] ; then 
	echo -e "Downloading Solr6 package...";
	wget -q wget -q https://download.alfresco.com/cloudfront/release/community/SearchServices/1.4.0/alfresco-search-services-1.4.0.zip ; 
else
  echo -e "Solr6 package already exists...skipping...";
fi
if [ ! -f apache-activemq-5.16.0-bin.tar.gz ] ; then 
	echo -e "Downloading ActiveMq package...";
	wget -O apache-activemq-5.16.0-bin.tar.gz -q "http://www.apache.org/dyn/closer.cgi?filename=/activemq/5.16.0/apache-activemq-5.16.0-bin.tar.gz&action=download" ; 
else
  echo -e "ActiveMq package already exists...skipping...";
fi
if [ ! -f alfresco-community.zip ] ; then 
	echo -e "Downloading RM (Govnernance Services) package...";
	wget -q https://download.alfresco.com/cloudfront/release/community/RM/3.0.a/alfresco-community.zip ; 
else
  echo -e "RM (Govnernance Services) package already exists...skipping...";
fi
if [ ! -f apache-tomcat-8.5.60.tar.gz ] ; then 
  echo -e "Downloading Tomcat package...!!!";
  	wget -q https://mirrors.sonic.net/apache/tomcat/tomcat-8/v8.5.60/bin/apache-tomcat-8.5.60.tar.gz ; 
else
  echo -e "Tomcat package already exists...skipping...";
fi

if [ ! -f rest-api-explorer.war ] ; then 
    echo -e "Downloading rest-api-explorer war file...";
  wget -q https://github.com/ajkr195/AlfrescoCommunityInstallation/raw/main/rest-api-explorer.war ; 
else
  echo -e "rest-api-explorer war file already exists...skipping...";
fi

if [ ! -f rm-rest-api-explorer.war ] ; then 
    echo -e "Downloading rm-rest-api-explorer war file...";
  wget -q https://github.com/ajkr195/AlfrescoCommunityInstallation/raw/main/rm-rest-api-explorer.war ; 
else
  echo -e "rm-rest-api-explorer war file already exists...skipping...";
fi


mkdir -p "$alfrescohome"/rm-apts
mkdir -p "$alfrescohome"/modules/share
mkdir -p "$alfrescohome"/modules/platform


echo -e "Unzipping packages..."
unzip -q -d "$alfrescohome" alfresco-content-services-community-distribution-6.2.0-ga.zip

mv "$alfrescohome"/alfresco-content-services-community-distribution-6.2.0-ga "$alfrescohome"/alfrescoacs

cp -r "$alfrescohome"/alfrescoacs/* "$alfrescohome"

rm -rf "$alfrescohome"/alfrescoacs

echo -e "copying rest-api war files..."

cp *.war "$alfrescohome"/web-server/webapps/

tar -xf apache-activemq-5.16.0-bin.tar.gz --directory "$alfrescohome"

mv "$alfrescohome"/apache-activemq-5.16.0 "$alfrescohome"/activemq

unzip -q -d "$alfrescohome"/rm-apts alfresco-community.zip

tar -xf apache-tomcat-8.5.60.tar.gz  --directory "$alfrescohome"

mv "$alfrescohome"/apache-tomcat-8.5.60 "$alfrescohome"/tomcat


unzip -q -d "$alfrescohome" alfresco-search-services-1.4.0.zip
mv "$alfrescohome"/alfresco-search-services "$alfrescohome"/alfrescoss

tar -xf "$alfrescohome"/alfresco-pdf-renderer/alfresco-pdf-renderer-1.1-linux.tgz --directory "$alfrescohome"/alfresco-pdf-renderer

rm -rf "$alfrescohome"/tomcat/webapps/*

cp "$alfrescohome"/web-server/webapps/*.war "$alfrescohome"/tomcat/webapps

cp -r "$alfrescohome"/web-server/conf/Catalina "$alfrescohome"/tomcat/conf

cp -r "$alfrescohome"/web-server/shared "$alfrescohome"/tomcat

mkdir -p "$alfrescohome"/tomcat/shared/lib

cp "$alfrescohome"/web-server/lib/*.jar "$alfrescohome"/tomcat/shared/lib


sleep 3
echo -e "Creating alfresco-global.properties..."

touch "$alfrescohome"/tomcat/shared/classes/alfresco-global.properties


cat << EOT > "$alfrescohome"/tomcat/shared/classes/alfresco-global.properties
dir.root=$alfrescohome/alf_data
dir.keystore=\${dir.root}/keystore
db.username=$dbownerusername
db.password=$dbowneruserpassword
db.driver=org.postgresql.Driver
db.url=jdbc:postgresql://localhost:5432/$alfrescodabasename
alfresco.context=alfresco
alfresco.host=localhost
alfresco.port=8080
alfresco.protocol=http
share.context=share
share.host=localhost
share.port=8080
share.protocol=http
alfresco.rmi.services.host=localhost
smart.folders.enabled=true
smart.folders.model=alfresco/model/smartfolder-model.xml
smart.folders.model.labels=alfresco/messages/smartfolder-model
alfresco-pdf-renderer.root=$alfrescohome/alfresco-pdf-renderer
alfresco-pdf-renderer.exe=${alfresco-pdf-renderer.root}/alfresco-pdf-renderer
alfresco-pdf-renderer.url=http://localhost:8090/
index.subsystem.name=solr6
solr.secureComms=none
solr.port=8983
messaging.broker.url=failover:(tcp://localhost:61616)?timeout=3000
transform.service.enabled=false
local.transform.service.enabled=false
legacy.transform.service.enabled=false
jodconverter.enabled=false 
jodconverter.officeHome=null
jodconverter.portNumbers=8100
EOT


sleep 3
echo -e "Configuring Solr6 for Non-SSL..."

sed -i 's/alfresco.secureComms=https/alfresco.secureComms=none/' "$alfrescohome"/alfrescoss/solrhome/templates/rerank/conf/solrcore.properties
sed -i 's/alfresco.port.ssl=8443/#alfresco.port.ssl=8443/' "$alfrescohome"/alfrescoss/solrhome/templates/rerank/conf/solrcore.properties
sleep 3


echo -e "Starting Solr6...Creating indexes..."
"$alfrescohome"/alfrescoss/solr/bin/solr start -a "-Dcreate.alfresco.defaults=alfresco,archive"  > /dev/null
sleep 20

sed -i 's/shared.loader=/#shared.loader=/' "$alfrescohome"/tomcat/conf/catalina.properties



echo 'shared.loader=${catalina.base}/shared/classes,${catalina.base}/shared/lib/*.jar' | tee -a "$alfrescohome"/tomcat/conf/catalina.properties > /dev/null


echo -e "Installing AMP files..."
java -jar "$alfrescohome"/bin/alfresco-mmt.jar install "$alfrescohome"/amps/alfresco-share-services.amp "$alfrescohome"/tomcat/webapps/alfresco.war
java -jar "$alfrescohome"/bin/alfresco-mmt.jar install "$alfrescohome"/rm-apts/alfresco-rm-community-repo-3.0.a.amp "$alfrescohome"/tomcat/webapps/alfresco.war
java -jar "$alfrescohome"/bin/alfresco-mmt.jar install "$alfrescohome"/rm-apts/alfresco-rm-community-share-3.0.a.amp "$alfrescohome"/tomcat/webapps/share.war


echo -e "Stopping Solr6..."
"$alfrescohome"/alfrescoss/solr/bin/solr stop   > /dev/null

echo -e "Cleaning unused files and directories..."
cp "$alfrescohome"/rm-apts/*.amp "$alfrescohome"/amps
rm -rf "$alfrescohome"/rm-apts
rm -rf "$alfrescohome"/web-server
rm "$alfrescohome"/alfresco-pdf-renderer/*.tgz


echo -e "Make sure you have the correct alf_home, database-name, username and password "
echo -e "in this file: Tomcat_Home/tomcat/shared/classes/alfresco-global.properties" 
