FROM debian:jessie
MAINTAINER Jean-Avit Promis "docker@katagena.com"

RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get -yq install wget default-jre && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget https://sourceforge.net/projects/ho1/files/ho1/1.433/HO_1433_r2501.deb/download
RUN dpkg -i download

RUN export uid=1000 gid=1000 && \
    mkdir -p /home/user/hrf/ && \
    echo "user:x:${uid}:${gid}:User,,,:/home/user:/bin/bash" >> /etc/passwd && \
    echo "user:x:${uid}:" >> /etc/group && \
    chown ${uid}:${gid} -R /home/user

USER user
ENV HOME /home/user
VOLUME /home/user/hrf/

CMD /usr/bin/ho1
