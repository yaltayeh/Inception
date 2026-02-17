*This project has been created as part of the 42 curriculum by yaltayeh.*

# Inception

## Description

This project aims to broaden the knowledge of system administration by using Docker. The goal is to virtualize several Docker images, creating into them a personal virtual machine.

The "Inception" project involves setting up a small infrastructure composed of different services under specific rules. The entire infrastructure must be built using `docker compose`.

## Instructions

### Prerequisites
- Docker Engine
- Docker Compose
- Make

### Installation & Execution

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/yaltayeh/Inception.git inception
    cd inception
    ```

2.  **Configure local domain:**
    Add the following line to your `/etc/hosts` file to map the domain name to your local machine:
    ```bash
    127.0.0.1 yaltayeh.42.fr
    ```

3.  **Setup environment:**
    Create the necessary configuration environment variables and folders.
    ```bash
    make config
    ```
    *Note: Ensure your `.env` file and secrets are correctly populated in `src/.env` and `secrets/` respectively.*

4.  **Build and Run:**
    Use the Makefile to build the images and start the containers.
    ```bash
    make
    ```
    This command will build the Docker images and start the network in detached mode.

5.  **Stop:**
    To stop the services:
    ```bash
    make clean
    ```
    To clean up everything (including images and volumes):
    ```bash
    make fclean
    ```

## Resources

### References
- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [NGINX Documentation](https://nginx.org/en/docs/)
- [WordPress Docker Image](https://hub.docker.com/_/wordpress)
- [MariaDB Docker Image](https://hub.docker.com/_/mariadb)

### AI Usage
Artificial Intelligence tools were utilized in this project for the following tasks:
- **Debugging Configuration:** AI assisted in troubleshooting syntax errors within `docker-compose.yml` and NGINX configuration files.
- **Script Optimization:** Suggestions were used to refine shell scripts for entrypoints, ensuring robust error handling.
- **Documentation:** AI helped outline and structure the documentation files (README, USER_DOC, DEV_DOC) to meet the specific requirements of the subject.

## Project Description

This project consists of setting up a complete web server infrastructure using Docker compose. The stack includes:
- A Docker container running **NGINX** with TLSv1.2 or TLSv1.3 only.
- A Docker container running **WordPress** + **php-fpm**.
- A Docker container running **MariaDB**.
- A Docker volume for the WordPress database.
- A Docker volume for the WordPress website files.
- A Docker network establishing the connection between containers.

### Design Choices & Comparisons

#### Virtual Machines vs Docker
| Feature | Virtual Machines (VM) | Docker (Containers) |
| :--- | :--- | :--- |
| **Architecture** | Runs a full guest OS on a hypervisor (hardware virtualization). | Shares the host OS kernel; isolates the application process (OS-level virtualization). |
| **Size** | Heavy (GBs) due to full OS. | Lightweight (MBs) as it only contains app and dependencies. |
| **Boot Time** | Minutes (OS boot). | Seconds (Process start). |
| **Isolation** | High isolation (distinct kernel). | Process-level isolation (shared kernel), less secure by default but sufficient for most apps. |

*Choice:* Docker was chosen for its lightweight nature and efficiency in resource usage compared to running three full VMs.

#### Secrets vs Environment Variables
| Feature | Environment Variables | Docker Secrets |
| :--- | :--- | :--- |
| **Storage** | Stored in plain text in the container configuration or `docker-compose` file. | Stored encrypted on the Swarm manager (or locally mounted as files in non-Swarm mode). |
| **Visibility** | Visible via `docker inspect` or `printenv` inside the container. | Only available as files mounted at `/run/secrets/` inside the container. |
| **Security** | Low. Easy to leak in logs or inspection. | High. Intended for sensitive data like passwords and keys. |

*Choice:* We use **Docker Secrets** for sensitive credentials (database passwords, admin passwords) to prevent them from being exposed in environment variables or command history.

#### Docker Network vs Host Network
| Feature | Docker Network (Bridge/Overlay) | Host Network |
| :--- | :--- | :--- |
| **Isolation** | Containers have their own IP and port space. Ports must be explicitly published. | Container shares the host's networking namespace directly. |
| **Security** | High. Only specified ports are exposed. | Lower. Container has full access to the host's network interfaces. |
| **Port Conflicts** | No conflicts between containers on different networks; easy to map to different host ports. | Potential conflicts if multiple services try to bind the same port on the host. |

*Choice:* A custom **Docker Bridge Network** is used to allow containers to communicate with each other internally (e.g., WordPress talking to MariaDB) without exposing internal services to the outside world, exposing only necessary ports (443) via NGINX.

#### Docker Volumes vs Bind Mounts
| Feature | Docker Volumes | Bind Mounts |
| :--- | :--- | :--- |
| **Management** | Managed by Docker (`/var/lib/docker/volumes/`). Easier to back up and migrate. | Managed by the user. Refers to a specific path on the host filesystem. |
| **Portability** | High. Abstracted away from the host file structure. | Low. Depends on the host's specific directory structure. |
| **Use Case** | Persisting data generated by and used by Docker containers. | Sharing config files or source code from the host to the container (dev environments). |

*Choice:* **Docker Volumes** are used for database persistence (`mariadb_data`) and web files (`web_data`) to ensure data persists across container restarts and is managed entirely by Docker.
