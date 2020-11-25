#!/bin/bash

alfrescohome=/home/<yourusernamehere>/Documents/alfresco620

killall java

rm -rf "$alfrescohome"/*

systemctl status postgresql > /dev/null
if [ "$?" -gt "0" ]; then
  echo -e "PostgreSQL Database Not Installed..\nError..!!!\nExiting now...!!!"
  exit 1; 
else
  echo -e "PostgreSQL is installed...Proceeding...!!!"
fi

echo -e "Downloading required packages...!!!\n"


if [ ! -f alfresco-content-services-community-distribution-6.2.0-ga.zip ] ; then 
    echo -e "Downloading ACS package...";
	wget -q https://download.alfresco.com/cloudfront/release/community/201911-GA-build-368/alfresco-content-services-community-distribution-6.2.0-ga.zip ; 
else
  echo -e "ACS package already exists...skipping...\n";
fi
if [ ! -f alfresco-search-services-1.4.0.zip ] ; then 
	echo -e "Downloading Solr6 package...";
	wget -q wget -q https://download.alfresco.com/cloudfront/release/community/SearchServices/1.4.0/alfresco-search-services-1.4.0.zip ; 
else
  echo -e "Solr6 package already exists...skipping...\n";
fi
if [ ! -f apache-activemq-5.16.0-bin.tar.gz ] ; then 
	echo -e "Downloading ActiveMq package...";
	wget -O apache-activemq-5.16.0-bin.tar.gz -q "http://www.apache.org/dyn/closer.cgi?filename=/activemq/5.16.0/apache-activemq-5.16.0-bin.tar.gz&action=download" ; 
else
  echo -e "ActiveMq package already exists...skipping...\n";
fi
if [ ! -f alfresco-community.zip ] ; then 
	echo -e "Downloading RM (Govnernance Services) package...";
	wget -q https://download.alfresco.com/cloudfront/release/community/RM/3.0.a/alfresco-community.zip ; 
else
  echo -e "RM (Govnernance Services) package already exists...skipping...\n";
fi
if [ ! -f apache-tomcat-8.5.60.tar.gz ] ; then echo -e "Downloading ACS package...!!!";
    echo -e "Downloading Tomcat package...";
	wget -q https://mirrors.sonic.net/apache/tomcat/tomcat-8/v8.5.60/bin/apache-tomcat-8.5.60.tar.gz ; 
else
  echo -e "Tomcat package already exists...skipping...\n";
fi


mkdir -p "$alfrescohome"/rm-apts
mkdir -p "$alfrescohome"/modules/share
mkdir -p "$alfrescohome"/modules/platform


echo -e "Unzipping packages in their respective home_dirs...!!!"
unzip -d "$alfrescohome" alfresco-content-services-community-distribution-6.2.0-ga.zip

mv "$alfrescohome"/alfresco-content-services-community-distribution-6.2.0-ga "$alfrescohome"/alfrescoacs

cp -r "$alfrescohome"/alfrescoacs/* "$alfrescohome"

rm -rf "$alfrescohome"/alfrescoacs

tar -xf apache-activemq-5.16.0-bin.tar.gz --directory "$alfrescohome"
mv "$alfrescohome"/apache-activemq-5.16.0 "$alfrescohome"/activemq

unzip -d "$alfrescohome"/rm-apts alfresco-community.zip

mv "$alfrescohome"/alfresco-community "$alfrescohome"/rm-apts

tar -xf apache-tomcat-8.5.60.tar.gz  --directory "$alfrescohome"

mv "$alfrescohome"/apache-tomcat-8.5.60 "$alfrescohome"/tomcat


unzip -d "$alfrescohome" alfresco-search-services-1.4.0.zip
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


cat << 'EOT' > "$alfrescohome"/tomcat/shared/classes/alfresco-global.properties
dir.root=/home/<yourusernamehere>/Documents/alfresco620/alf_data
dir.keystore=${dir.root}/keystore
db.username=newtestdb
db.password=newtestdb
db.driver=org.postgresql.Driver
db.url=jdbc:postgresql://localhost:5432/newtestdb
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
alfresco-pdf-renderer.root=/home/ajay/Documents/alfresco/alfresco-pdf-renderer
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
"$alfrescohome"/alfrescoss/solr/bin/solr start -a "-Dcreate.alfresco.defaults=alfresco,archive" 
sleep 20

sed -i 's/shared.loader=/#shared.loader=/' "$alfrescohome"/tomcat/conf/catalina.properties



echo 'shared.loader=${catalina.base}/shared/classes,${catalina.base}/shared/lib/*.jar' | tee -a "$alfrescohome"/tomcat/conf/catalina.properties

echo -e "Installing AMP files..."
java -jar "$alfrescohome"/bin/alfresco-mmt.jar install "$alfrescohome"/amps/alfresco-share-services.amp "$alfrescohome"/tomcat/webapps/alfresco.war
java -jar "$alfrescohome"/bin/alfresco-mmt.jar install "$alfrescohome"/rm-apts/alfresco-rm-community-repo-3.0.a.amp "$alfrescohome"/tomcat/webapps/alfresco.war
java -jar "$alfrescohome"/bin/alfresco-mmt.jar install "$alfrescohome"/rm-apts/alfresco-rm-community-share-3.0.a.amp "$alfrescohome"/tomcat/webapps/share.war


echo -e "Stopping Solr6..."
"$alfrescohome"/alfrescoss/solr/bin/solr stop 
sleep 5

echo -e "Make sure you have the correct database-name, username and password....in this file: Tomcat_Home/tomcat/shared/classes/alfresco-global.properties"
sleep 5
