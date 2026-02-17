FROM debian:12-slim

RUN apt update && \
    apt install -y openssh-server && \
    mkdir -p /run/sshd && \
    ssh-keygen -A

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

RUN echo "UsePAM no" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

EXPOSE 22

HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD ssh -o BatchMode=yes -o ConnectTimeout=5 ftpuser@localhost -p 22 exit || exit 1

ENTRYPOINT [ "/entrypoint.sh" ]
CMD ["/usr/sbin/sshd", "-D"]
