# AlfrescoCommunityInstallation
Alfresco Community Edition "New Installation" Steps

<h4> Download Links for Software Packages:</h4> 

1. Distribution (ACS): https://download.alfresco.com/cloudfront/release/community/201911-GA-build-368/alfresco-content-services-community-distribution-6.2.0-ga.zip<br>
2. Search Services (SOLR6): https://download.alfresco.com/cloudfront/release/community/SearchServices/1.4.0/alfresco-search-services-1.4.0.zip<br>
3. ActiveMQ: http://www.apache.org/dyn/closer.cgi?filename=/activemq/5.16.0/apache-activemq-5.16.0-bin.tar.gz&action=download<br>
4. Records Management (RM): https://download.alfresco.com/cloudfront/release/community/RM/3.0.a/alfresco-community.zip<br>
5. Tomcat (WebServer): https://mirrors.sonic.net/apache/tomcat/tomcat-8/v8.5.60/bin/apache-tomcat-8.5.60.tar.gz


<h4> Now extract/unzip/untar - </h4> 

 Extract #1 in our Alfresco_HOME. Say - /home/user/alfresco<br>
 Extract #2 in our Solr_HOME - Alfresco_HOME/alfrescoss  
 Extract #3 in our ActiveMQ_HOME - Alfresco_HOME/activemq  
 Extract #4 in Alfresco_HOME/rm-amps<br>
 Extract #5 in our Tomcat_HOME- Alfresco_HOME/tomcat 
 <h4> Files/dirs structure copy/creation steps:</h4><br> 
 <ol>
 <li>Copy Alfresco_HOME/web-server/conf/Catalina directory in Alfresco_HOME/tomcat/conf directory </li>
 <li>Copy Alfresco_HOME/web-server/shared directory inside Tomcat_HOME. That is - Alfresco_HOME/tomcat </li>
 <li>Create a directory "lib" in Alfresco_HOME/tomcat/shared/  so that you have a path - Alfresco_HOME/tomcat/shared/lib </li>
 <li>Now copy Alfresco_HOME/web-server/lib/postgresql-x.y.z.jar to the directory created in above step. That is - Alfresco_HOME/tomcat/shared/lib</li>
 <li>Empty Alfresco_HOME/tomcat/webapps directory. That means - Delete everything inside this directory - Alfresco_HOME/tomcat/webapps </li>
 <li>Now copy all .war files from Alfresco_HOME/web-server/webapps/ to Alfresco_HOME/tomcat/webapps directory </li>
 <li> Create directory - Alfresco_HOME/modules</li>
 <li> Create directory - Alfresco_HOME/modules/platform</li>
 <li> Create directory - Alfresco_HOME/modules/share</li>
 <li>Update Tomcat_HOME/conf/catalina.properties file. Search for - "shared.loader=" and update it like this -  shared.loader=${catalina.base}/shared/classes,${catalina.base}/shared/lib/*.jar </li>
 <li> Create directory - Alfresco_HOME/modules</li>
 </ol>
 
 <li> </li>
  
 
 
 
