FROM ubuntu:trusty

MAINTAINER nicolaihald

ENV APT_GET_UPDATE 2016-05-16
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive \
  apt-get -q -y install openjdk-7-jre-headless wget unzip \
  && apt-get clean

ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64