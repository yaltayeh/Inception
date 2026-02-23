This project has been created as part of the 42 curriculum by yaltayeh.

# Microservices Lab 


# Description

This project is a microservices lab that demonstrates the use of Docker and Docker Compose to create and manage multiple services. The project includes a simple two web application one in nextjs and the other in wordpress, a mariaDB database, and a adminer database management tool. The services are defined in a `docker-compose.yml` file and can be easily started, stopped, and managed using `make` commands.

## structure
```
src
├── docker-compose.yml
└── services
    ├── adminer
    ├── ftp_server
    ├── mariadb
    ├── n8n
    ├── nextjs
    ├── nginx
    ├── redis
    └── wordpress
```

## Virtual Machines vs Docker

docker is a child process isolated by the kernel, while a virtual machine is a full operating system running on top of a hypervisor. Docker is more lightweight and faster to start than a virtual machine, but it may not provide the same level of isolation and security as a virtual machine.


## Secrets vs Environment Variables

Secrets are a more secure way to store sensitive information, such as passwords and API keys, than environment variables. Secrets are encrypted and can only be accessed by authorized users, while environment variables can be easily accessed by anyone who has access to the system.

## Docker Network vs Host Network

Docker network is a virtual network that allows containers to communicate with each other, while host network allows containers to use the host's network stack. Docker network provides better isolation and security, while host network can be faster and more efficient for certain use cases.

## Docker Volumes vs Bind Mounts

Docker volumes are a more flexible and portable way to store data than bind mounts. Docker volumes are managed by Docker and can be easily shared between containers, while bind mounts are tied to the host's file system and may not work well across different environments.

notes: when create the file in container by root user, the file will be owned by root and may not be accessible by other users. To avoid this issue, you can use the `--user` flag when running the container to specify a non-root user, or you can change the ownership of the file after it is created. For example, you can use the `chown` command to change the ownership of the file to a non-root user.

## Instructions

### 1. install docker
#### open https://docs.docker.com/engine/install and follow the instructions for your operating system.
--------
### 2. install docker-compose
#### open https://docs.docker.com/compose/install and follow the instructions for your operating system.

--------
### 3. Add your domain to hosts /etc/hosts (requierd sudo permisstion)

``` sh
sudo vim /etc/hosts
# and add 127.0.0.1   yaltayeh.42.fr    
```

--------
### 4. now you can run the following command to start the services:
``` sh
make config
```

``` sh
make build
```

``` sh
make
```

you can also run the following command to stop the services:
``` sh
make stop
```

and use the following command to check the status of the services:
``` sh
make status

```

and use the following command to clean up the services:
``` sh
make clean
# for remove the images and volumes, you can use the following command:
make fclean
```

and use the following command to view the logs of the services:
``` sh
make logs
```


## Resources
use https://docs.docker.com/ai/gordon/ to learn more about docker and its features.

ask chatgpt for help if you have any questions or issues with the project.

عليك أن تتعلم Docker الآن!! // Docker Containers 101
https://youtu.be/eGz9DS-aIeY

Production Deployment on VPS using Docker | رفع تطبيق على استضافة باستخدام دوكر
https://youtu.be/C7aooGtKq8Y

شبكات الحاسوب: شرح تصميم الـ OSI وكيف يتم نقل البيانات؟ وما هيه ال Physical layer ؟ (3)
https://youtu.be/9rsYu0es3XE

## Usage
open [USER_DOC.md](docs/USER_DOC.md) for more information about how to use the services and access the applications.

and open [DEV_DOC.md](docs/DEV_DOC.md) for more information about how to develop and customize the services and applications.
