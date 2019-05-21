FROM php:7.3-fpm-stretch

RUN apt-get update && apt-get install -y supervisor rsyslog cron

# Enable SSH: ##################################################################
ARG LINUX_ROOT_PASSWORD
ENV LINUX_ROOT_PASSWORD ${LINUX_ROOT_PASSWORD}

RUN apt-get update && apt-get install -y openssh-server pwgen && \
    mkdir -p /var/run/sshd && \
    if [ ! -z "${LINUX_ROOT_PASSWORD}" ]; then echo "root:${LINUX_ROOT_PASSWORD}" | chpasswd; else export LINUX_ROOT_PASSWORD="$(pwgen -1 32)" && printf "${LINUX_ROOT_PASSWORD}\n" >> /.env && echo "root:${LINUX_ROOT_PASSWORD}" | chpasswd; fi && \
    sed -i -r 's/^#?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i -r 's/^#?PermitEmptyPasswords.*/PermitEmptyPasswords yes/' /etc/ssh/sshd_config && \
    sed -i -r 's:^#?AuthorizedKeysFile.*:AuthorizedKeysFile %h/.ssh/authorized_keys:' /etc/ssh/sshd_config && \
    sed -i -r 's/^#?GatewayPorts.*/GatewayPorts yes/' /etc/ssh/sshd_config && \
    sed -i -r 's/^#?PermitTunnel.*/PermitTunnel yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise user is kicked off after login
RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

RUN rm -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa && \
    rm -f /etc/ssh/ssh_host_dsa_key && \
    ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa && \
    rm -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa && \
    rm -f /etc/ssh/ssh_host_ed25519_key && \
    ssh-keygen -f /etc/ssh/ssh_host_ed25519_key -N '' -t ed25519

EXPOSE 22
# END: enable SSH ###################################################################################################

RUN mkdir -p /var/www/content && rmdir /var/www/html

# Used by the wait_for_mysql.sh script
RUN apt-get update && apt-get install -y \
    mariadb-client

# Used by the wait_for_ssh_keys.sh script
RUN apt-get update && apt-get install -y \
    netcat

# From composer:
# As there is no 'unzip' command installed zip files are being unpacked using the PHP zip extension.
# This may cause invalid reports of corrupted archives. Besides, any UNIX permissions (e.g. executable) defined in the archives will be lost.
# Installing 'unzip' may remediate them.
# libcurl4-openssl-dev required to build php_curl, libpng-dev required to build php_gd, libxml2-dev required to build php_xml
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libpng-dev \
    libxml2-dev \
    libzip-dev \
    unzip \
    git

# composer needs php_zip to extract dist packages
RUN docker-php-ext-install \
    zip \
    mysqli \
    pdo_mysql \
    curl \
    soap \
    json \
    gd \
    mbstring \
    xml \
    bcmath \
    pcntl

RUN docker-php-ext-enable \
    zip \
    mysqli \
    pdo_mysql \
    curl \
    soap \
    json \
    gd \
    mbstring \
    xml \
    bcmath \
    pcntl

RUN pecl install redis

#RUN pecl install xdebug
#COPY ./php/php.d/xdebug.ini /usr/local/etc/php/conf.d/
RUN curl -L https://xdebug.org/files/xdebug-2.7.2.tgz -o /tmp/xdebug-2.7.2.tgz && \
    cd /tmp && \
    tar xzf /tmp/xdebug-2.7.2.tgz && \
    cd /tmp/xdebug-2.7.2 && \
    phpize && \
    ./configure --enable-xdebug && \
    make && \
    make install

# Needed because the volumes retain the host's UID and GID inside the container which results in permission denied issues when writing
RUN usermod -u 1000 www-data
RUN usermod -G staff www-data

EXPOSE 9090
WORKDIR /var/www/content
ENTRYPOINT ["/usr/bin/env"]
CMD ["cmd_master.sh"]
