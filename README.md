# AlfrescoCommunityInstallation
Alfresco Community Edition "New Installation" Steps

<h4> Download Links for Software Packages:</h4> 

1. Distribution (ACS): https://download.alfresco.com/cloudfront/release/community/201911-GA-build-368/alfresco-content-services-community-distribution-6.2.0-ga.zip<br>
2. Search Services (SOLR6): https://download.alfresco.com/cloudfront/release/community/SearchServices/1.4.0/alfresco-search-services-1.4.0.zip<br>
3. ActiveMQ: http://www.apache.org/dyn/closer.cgi?filename=/activemq/5.16.0/apache-activemq-5.16.0-bin.tar.gz&action=download<br>
4. Records Management (RM): https://download.alfresco.com/cloudfront/release/community/RM/3.0.a/alfresco-community.zip<br>
5. Tomcat (WebServer): https://mirrors.sonic.net/apache/tomcat/tomcat-8/v8.5.60/bin/apache-tomcat-8.5.60.tar.gz


<h4> Now extract/unzip/untar - </h4> 

 Extract #1 in a directory. This will be our Alfresco_HOME. Say - /home/user/alfresco<br>
 Extract #2 in a directory. This will be our Solr_HOME - Alfresco_HOME/alfrescoss  
 Extract #3 in a directory. This will be our ActiveMQ_HOME - Alfresco_HOME/activemq  
 Extract #4 in Alfresco_HOME/rm-amps 
 Extract #5 in a directory. This will be our Tomcat_HOME- Alfresco_HOME/tomcat 
 <h4> Files/dirs structure copy steps:</h4><br> 
 Copy all files/directories from the dirs of Alfresco_HOME/web-server to the corresponding dirs of Alfresco_HOME/tomcat directory like below:<br> 
 1. Copy Alfresco_HOME/web-server/conf/Catalina directory in Alfresco_HOME/tomcat/conf directory<br> 
 2. Copy Alfresco_HOME/web-server/shared directory inside Tomcat_HOME. That is - Alfresco_HOME/tomcat<br> 
 3. Create a directory "lib" in Alfresco_HOME/tomcat/shared/  so that you have a path - Alfresco_HOME/tomcat/shared/lib<br> 
 4. Now copy Alfresco_HOME/web-server/lib/postgresql-x.y.z.jar to the directory created in above step. That is - Alfresco_HOME/tomcat/shared/lib<br> 
 5. Empty Alfresco_HOME/tomcat/webapps directory. That means - Delete everything inside this directory - Alfresco_HOME/tomcat/webapps<br> 
 6. Now copy all .war files from Alfresco_HOME/web-server/webapps/ to Alfresco_HOME/tomcat/webapps directory<br> 
 Create these directories - 
 
 Alfresco_HOME/modules<br> 
 Alfresco_HOME/modules/platform<br> 
 Alfresco_HOME/modules/share<br> 
 shared.loader=${catalina.base}/shared/classes,${catalina.base}/shared/lib/*.jar
 
 
