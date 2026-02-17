FROM debian:12-slim

RUN apt update && \
    apt install -y openssh-server && \
    mkdir -p /run/sshd && \
    ssh-keygen -A

RUN useradd -m ftpuser && \
    echo "ftpuser:password" | chpasswd

RUN echo "UsePAM no" >> /etc/ssh/sshd_config && \
    echo "PasswordAuthentication yes" >> /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
