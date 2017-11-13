# Dockerfile for Epistemics

FROM	tomcat:8-jre8

ENV	VERSION 1.3.0-SNAPSHOT
ENV	ARTIFACTORY_URL http://artifactory:8081/artifactory/libs-release-local/selemca

ADD	epistemics-beliefsystem-rest-${VERSION}.war /usr/local/tomcat/webapps/beliefsystem-rest.war
ADD	epistemics-beliefsystem-webadmin-${VERSION}.war /usr/local/tomcat/webapps/beliefsystem-webadmin.war
ADD	epistemics-mentalworld-webapp-${VERSION}.war /usr/local/tomcat/webapps/mentalworld-webapp.war
ADD	epistemics-mentalworld-webadmin-${VERSION}.war /usr/local/tomcat/webapps/mentalworld-webadmin.war
ADD	epistemics-mentalworld-rest-${VERSION}.war /usr/local/tomcat/webapps/mentalworld-rest.war

