FROM hypriot/rpi-mysql
MAINTAINER sameer@damagehead.com

RUN apt-get update -y
RUN apt-get install -y apache2
RUN apt-get install -y mysql-server
RUN apt-get install -y curl
RUN apt-get install -y aptitude
RUN aptitude install -y supervisor logrotate nginx mysql-client postgresql-client 
RUN aptitude install -y imagemagick 
RUN aptitude install -y subversion 
RUN aptitude install -y git 
RUN aptitude install -y cvs 
RUN aptitude install -y bzr 
RUN aptitude install -y mercurial 
RUN aptitude install -y darcs 
RUN aptitude install -y rsync 
RUN aptitude install -y ruby2.1 
RUN aptitude install -y locales 
RUN aptitude install -y openssh-client
RUN aptitude install -y gcc 
RUN aptitude install -y g++ 
RUN aptitude install -y make 
RUN aptitude install -y patch 
RUN aptitude install -y pkg-config 
RUN aptitude install -y gettext-base 
RUN aptitude install -y ruby2.1-dev 
RUN aptitude install -y libc6-dev 
RUN aptitude install -y zlib1g-dev 
RUN aptitude install -y libxml2-dev
RUN aptitude install -y libmysqlclient18 
RUN aptitude install -y libpq5 
RUN aptitude install -y libyaml-0-2 
RUN aptitude install -y libcurl3 
RUN aptitude install -y libssl1.0.0
RUN aptitude install -y libxslt1.1 
RUN aptitude install -y libffi6 
RUN aptitude install -y zlib1g 
RUN aptitude install -y gsfonts 

ENV REDMINE_VERSION=3.1.3 \
    REDMINE_USER="redmine" \
    REDMINE_HOME="/home/redmine" \
    REDMINE_LOG_DIR="/var/log/redmine" \
    REDMINE_CACHE_DIR="/etc/docker-redmine" \
    RAILS_ENV=production

ENV REDMINE_INSTALL_DIR="${REDMINE_HOME}/redmine" \
    REDMINE_DATA_DIR="${REDMINE_HOME}/data" \
    REDMINE_BUILD_DIR="${REDMINE_CACHE_DIR}/build" \
    REDMINE_RUNTIME_DIR="${REDMINE_CACHE_DIR}/runtime"



COPY assets/build/ ${REDMINE_BUILD_DIR}/

RUN apt-get install -y wget tar
RUN bash ${REDMINE_BUILD_DIR}/install.sh

COPY assets/runtime/ ${REDMINE_RUNTIME_DIR}/
COPY assets/tools/ /usr/bin/
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 80/tcp 443/tcp

VOLUME ["${REDMINE_DATA_DIR}", "${REDMINE_LOG_DIR}"]
WORKDIR ${REDMINE_INSTALL_DIR}
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["app:start"]
