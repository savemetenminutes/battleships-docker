FROM httpd:2.4

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

RUN mkdir -p /var/www/content

# Needed because the volumes retain the host's UID and GID inside the container which results in permission denied issues when writing
RUN usermod -u 1000 www-data
RUN usermod -G staff www-data

EXPOSE 80 81 82 83 84 85 86 87 88 89 90 443 481 482 483 484 485 486 487 488 489 490
WORKDIR /var/www/content
ENTRYPOINT ["/usr/bin/env"]
CMD ["cmd_master.sh"]