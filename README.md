# Alfresco Community Edition 6.2.0 Installation

<h4> Alfresco Community Edition 6.2.0 "New Installation" <br> All-In-One Steps (only HTTP, without SSL configuration) </h4> 

<h4> Ubuntu Mate 20.04.01 LTS is used in this example </h4> 

<h4> Sand-Box Pre-Requisites:</h4> 

Installed JDK version - 11.x (for ubuntu - sudo apt install openjdk-11-jdk)<br>
Installed Postgresql - 11.x. A new and empty database-name and a dbusername who is the owner of the database and the password.
https://computingforgeeks.com/install-postgresql-11-on-ubuntu-linux/<br>
https://pgdash.io/blog/postgres-11-getting-started.html

<h2>Automated Installation </h2>
<h4>Entire setup process takes less than 2 minutes + packages download time</h4>
<ol>
<li>Download <b>alfresco_automated_installation.sh</b>  from here - https://github.com/ajkr195/AlfrescoCommunityInstallation </li>
<li>Update these line #  8, 9, 10, and 11 as per your environment in your downloaded alfresco_automated_installation.sh file</li>
<li>Run ./alfresco_automated_installation.sh </li>
<li>The script will download packages, unzip/untar and configure them. Jump to "System Start" section after this. </li>
</ol>

<h2>Manual Installation </h2>

<h4> Download Links for Software Packages:</h4> 

1. Distribution (ACS): https://download.alfresco.com/cloudfront/release/community/201911-GA-build-368/alfresco-content-services-community-distribution-6.2.0-ga.zip<br>
2. Search Services (SOLR6): https://download.alfresco.com/cloudfront/release/community/SearchServices/1.4.0/alfresco-search-services-1.4.0.zip<br>
3. ActiveMQ: http://www.apache.org/dyn/closer.cgi?filename=/activemq/5.16.0/apache-activemq-5.16.0-bin.tar.gz&action=download<br>
4. Records Management (RM): https://download.alfresco.com/cloudfront/release/community/RM/3.0.a/alfresco-community.zip<br>
5. Tomcat (WebServer): https://mirrors.sonic.net/apache/tomcat/tomcat-8/v8.5.60/bin/apache-tomcat-8.5.60.tar.gz


<h4> Extract/UNZIP/UNTAR - </h4> 
<ul>
<li> Extract #1 in our Alfresco_HOME. Say - /home/user/Documents/alfresco</li> 
<li>  Extract #2 in our Solr_HOME - Alfresco_HOME/alfrescoss  </li> 
<li>  Extract #3 in our ActiveMQ_HOME - Alfresco_HOME/activemq  </li> 
<li>  Extract #4 in Alfresco_HOME/rm-amps<br></li> 
<li>  Extract #5 in our Tomcat_HOME- Alfresco_HOME/tomcat</li>  
<li>  Extract Alfresco_HOME/alfresco-pdf-renderer/alfresco-pdf-renderer-1.1-linux.tgz in this directory - Alfresco_HOME/alfresco-pdf-renderer</li> 
</ul>
 
 
 <h4> Files/dirs structure copy/creation steps:</h4>
 <ol>
 <li>Copy Alfresco_HOME/web-server/conf/Catalina directory in Tomcat_HOME/conf directory </li>
 <li>Copy Alfresco_HOME/web-server/shared directory inside Tomcat_HOME like so - Tomcat_HOME/shared </li>
 <li>Create a directory "lib" in Tomcat_HOME/shared/  so that you have a path - Tomcat_HOME/shared/lib </li>
 <li>Now copy Alfresco_HOME/web-server/lib/postgresql-x.y.z.jar to the directory created in above step. That is - Tomcat_HOME/shared/lib</li>
 <li>Empty Tomcat_HOME/webapps directory. That means - Delete everything inside this directory - Tomcat_HOME/webapps </li>
 <li>Now copy all .war files from Alfresco_HOME/web-server/webapps/ to Tomcat_HOME/webapps directory </li>
 <li>OPTIONAL - <br>Build and create your ACS REST API Explorer war file using "mvn clean install" from here - https://github.com/Alfresco/rest-api-explorer <br> and here <br> https://github.com/Alfresco/records-management/tree/master/rm-community/rm-community-rest-api-explorer <br> OR <br> Download them from https://github.com/ajkr195/AlfrescoCommunityInstallation/blob/main/rest-api-explorer.war and https://github.com/ajkr195/AlfrescoCommunityInstallation/blob/main/rm-rest-api-explorer.war</li>
 <li>OPTIONAL - <br>Copy above two generated/downloaded war files to Tomcat_HOME/webapps directory</li>
 <li> Create directory - Alfresco_HOME/modules</li>
 <li> Create directory - Alfresco_HOME/modules/platform</li>
 <li> Create directory - Alfresco_HOME/modules/share</li>
 <li>Update Tomcat_HOME/conf/catalina.properties file. Search for - "shared.loader=" and update it like this -  shared.loader=${catalina.base}/shared/classes,${catalina.base}/shared/lib/*.jar </li>
<li>Download this file - https://github.com/ajkr195/AlfrescoCommunityInstallation/blob/main/alfresco-global.properties and place it in this directory - Tomcat_HOME/shared/classes <br> Make sure you have correct database name and user+password as per pre-requisites in this file </li>
 </ol>
<h4>Configure Solr6</h4>
<ol>
<li>Comment/delete this line - alfresco.port.ssl=8443 in Solr_HOME/solrhome/templates/rerank/conf/solrcore.properties </li>
<li>Change this line - alfresco.secureComms=https to alfresco.secureComms=none in Solr_HOME/solrhome/templates/rerank/conf/solrcore.properties</li>
<li>Save and close Solr_HOME/solrhome/templates/rerank/conf/solrcore.properties file</li>
<li>Run this command Solr_HOME/solr/bin/solr start -a "-Dcreate.alfresco.defaults=alfresco,archive" </li>
</ol>

<h4>Install Share and Records Manager (Governance Services) amp (Alfresco-Module-Packages) files </h4>
<ol>
<li>java -jar Alfresco_HOME/bin/alfresco-mmt.jar install Alfresco_HOME/amps/alfresco-share-services.amp Tomcat_HOME/webapps/alfresco.war</li>
<li>java -jar Alfresco_HOME/bin/alfresco-mmt.jar install Alfresco_HOME/rm-amps/alfresco-rm-community-repo-3.0.a.amp Tomcat_HOME/webapps/alfresco.war</li>
<li>java -jar Alfresco_HOME/bin/alfresco-mmt.jar install Alfresco_HOME/rm-amps/alfresco-rm-community-share-3.0.a.amp Tomcat_HOME/webapps/share.war</li>
</ol>
 
 
<h4>System Start: </h4>
<ol>
<li>Run this command - ActiveMQ_HOME/bin/activemq start</li>
<li>Run this command - Tomcat_HOME/bin/startup.sh & disown</li>
<li>Run this command - Solr_HOME/solr/bin/solr start</li>
</ol>

<h4>URLs: </h4>
 http://localhost:8080/alfresco<br>
 http://localhost:8080/share<br>
 http://localhost:8080/rest-api-explorer<br>
 http://localhost:8080/rm-rest-api-explorer<br>
 http://localhost:8080/alfresco/service/index/all<br>


<h4>Default Admin username and password - </h4><h2> admin/admin </h2>

<h4>System Stop: </h4>
<ul>
<li>Run this command - ps -ef |grep java</li>
<li>Identify java process ids for tomcat, solr and activemq</li>
<ol>
<li>Kill tomcat instance of java (Required)</li>
<li>Kill solr instance of java (Required)</li>
<li>Kill acativemq instance of java (Optional)</li>
 </ol>
</ul>
