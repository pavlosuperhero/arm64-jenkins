FROM arm64v8/ubuntu:bionic

RUN apt-get update &&\
	DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata &&\ 
	ln -fs /usr/share/zoneinfo/Europe/Kiev /etc/localtime &&\
	apt-get install curl wget openjdk-8-jdk gnupg -y &&\
	wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | apt-key add - && \
	echo 'deb http://pkg.jenkins.io/debian-stable binary/' > /etc/apt/sources.list.d/jenkins.list &&\
	apt-get update && apt-get install jenkins -y
COPY upstart.sh /upstart.sh
ENTRYPOINT [ "/bin/bash", "/upstart.sh" ]
EXPOSE 8080
EXPOSE 50000
HEALTHCHECK --interval=15s CMD curl -f http://localhost:8080/login || exit 1
USER jenkins
WORKDIR /var/jenkins_home
