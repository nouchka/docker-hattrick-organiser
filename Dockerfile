FROM debian:jessie
LABEL maintainer="Jean-Avit Promis docker@katagena.com"

LABEL org.label-schema.vcs-url="https://github.com/nouchka/docker-ho"
LABEL version="latest"

ARG HO_FILE_SHA256SUM=f37618d8ec16f85c404af8a1bd39dd1c03ab781f747b1c23693f82819cd79549
ARG HO_FILE_VERSION=1.434/HO_1434_r2696
ENV VERSION ${HO_FILE_VERSION}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get -yq --no-install-recommends install wget=* default-jre=* && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	wget -O /tmp/ho.deb https://sourceforge.net/projects/ho1/files/ho1/${HO_FILE_VERSION}.deb/download && \
	echo "${HO_FILE_SHA256SUM}  /tmp/ho.deb"| sha256sum -c - && \
	dpkg -i /tmp/ho.deb && \
	export uid=1000 gid=1000 && \
	mkdir -p /home/user/hrf/ && \
	echo "user:x:${uid}:${gid}:User,,,:/home/user:/bin/bash" >> /etc/passwd && \
	echo "user:x:${uid}:" >> /etc/group && \
	chown ${uid}:${gid} -R /home/user

USER user
ENV HOME /home/user
VOLUME /home/user/hrf/

ENTRYPOINT [ "/usr/bin/ho1" ]
