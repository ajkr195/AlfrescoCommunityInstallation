#!/bin/bash


alfrescohome=/home/<yourusername>/Documents/alfresco620_2

echo "Killing all java processes..."
killall java
killall java
sleep 3
echo "Killing all java processes...COMPLETED...!!!"
echo "Cleaning logs...!!!"
rm "$alfrescohome"/alfrescoss/logs/solr.log
rm -rf "$alfrescohome"/tomcat/work/*
rm "$alfrescohome"/tomcat/logs/*
echo "Cleaning logs...COMPLETED...!!!"
sleep 3

echo "Starting activemq...."
"$alfrescohome"/activemq/bin/activemq start
sleep 3
echo "Starting tomcat...."
"$alfrescohome"/tomcat/bin/startup.sh & disown
sleep 3
echo "Starting solr...."
"$alfrescohome"/alfrescoss/solr/bin/solr start
sleep 2
echo "All services are up now...."