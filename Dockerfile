FROM debian:sid-slim
LABEL maintainer="Jean-Avit Promis docker@katagena.com"

LABEL org.label-schema.vcs-url="https://github.com/nouchka/docker-ho"
LABEL version="latest"

ARG HO_FILE_SHA256SUM=ff4709b9300af8a5d3b035ae54cb3364a5a265d4ff3605c6f191433a77045cf4
ARG HO_FILE_VERSION=4.1
ENV VERSION ${HO_FILE_VERSION}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get -yq --no-install-recommends install wget=* openjdk-17-jre=* && \
	rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
	wget -O /usr/bin/ho -q https://github.com/akasolace/HO/releases/download/${HO_FILE_VERSION}/HO-4.1.3310.2-unix.sh && \
	sha256sum /usr/bin/ho && \
	echo "${HO_FILE_SHA256SUM}  /usr/bin/ho"| sha256sum -c - && \
	chmod +x /usr/bin/ho && \
	export uid=1000 gid=1000 && \
	mkdir -p /home/user/hrf/ && \
	echo "user:x:${uid}:${gid}:User,,,:/home/user:/bin/bash" >> /etc/passwd && \
	echo "user:x:${uid}:" >> /etc/group && \
	chown ${uid}:${gid} -R /home/user

COPY docker-entrypoint.sh /docker-entrypoint.sh
USER user
ENV HOME /home/user
VOLUME /home/user/hrf/ /home/user/.ho/

ENTRYPOINT [ "/docker-entrypoint.sh" ]
