# Developer Documentation (DEV_DOC)

## 1. Set Up the Environment

### Prerequisites
Ensure the development machine has the following installed:
*   **Git** - For cloning the repository
*   **Make** - For running build commands
*   **Docker Engine** - For running containers
*   **Docker Compose** - For orchestrating multi-container setup

Verify installations:
```bash
git --version
make --version
docker --version
docker-compose --version
```

### Configuration Files
The project relies on a `.env` file located in `src/` and secret files in the `secrets/` directory.

To initialize these automatically, running the configuration script is recommended:
```bash
make config
```
This script (located at `scripts/configuration.sh`) generates:
1.  **`src/.env`**: Contains environment variables for compose (e.g., `DOMAIN_NAME`, `MYSQL_DATABASE`).
2.  **`secrets/` folder**: Contains sensitive text files (e.g., `db_password.txt`, `admin_password.txt`).

**Manual Setup:**
If setting up manually, ensure `src/.env` mirrors the variables required in `src/docker-compose.yml` and that the `secrets` path in the compose file points to valid files.

**Required Secrets Files:**
Create these files in the `secrets/` directory:
- `wordpress_admin_password.txt` - WordPress admin password
- `mysql_root_password.txt` - MariaDB root password
- `mysql_user_password.txt` - MariaDB application user password
- `ftp_password.txt` - FTP user password
- `<DOMAIN_NAME>.key` - SSL private key
- `<DOMAIN_NAME>.crt` - SSL certificate

**Required Environment Variables:**
Key variables in `src/.env`:
- `DOMAIN_NAME` - Your domain (e.g., localhost or example.com)
- `MYSQL_DATABASE` - Database name (default: wordpress)
- `MYSQL_USER` - Database user (default: wordpress)
- `WORDPRESS_ADMIN_USER` - WordPress admin username
- `WORDPRESS_ADMIN_EMAIL` - WordPress admin email

## 2. Build and Launch

The project uses a `Makefile` at the root for easy orchestration.

**Build images:**
To build all Docker images without starting containers:
```bash
make build
```
This builds images for: MariaDB, nginx, WordPress, redis, n8n, ftp_server, and adminer.

**Build specific service:**
```bash
docker-compose -f src/docker-compose.yml build <service-name>
```

**Launch Project:**
To build (if changed) and start all containers in detached mode:
```bash
make
```
Or explicitly:
```bash
make up
```

**Using Docker Compose directly:**
```bash
cd src && docker-compose up -d
```

**View running services:**
```bash
make ps
```

## 3. Manage Containers and Volumes

### Container Management

| Command | Description |
|---------|-------------|
| `make` or `make up` | Start all services |
| `make build` | Build all images |
| `make stop` | Stop all containers |
| `make clean` | Stop and remove containers |
| `make fclean` | Full cleanup (containers, networks, volumes, images) |
| `make ps` | Show running containers |
| `make logs` | View real-time logs |
| `make status` | Run health checks |

**Container-specific commands:**

*   **Stop containers:**
    ```bash
    make stop
    ```

*   **Restart containers:**
    ```bash
    make clean && make
    ```

*   **View live logs (all services):**
    ```bash
    make logs
    ```

*   **View logs for specific service:**
    ```bash
    docker logs -f <container-name>
    ```
    Example: `docker logs -f wordpress`

*   **Stop and remove all containers, networks, and volumes:**
    ```bash
    make fclean
    ```

*   **Show running containers:**
    ```bash
    make ps
    ```

*   **Execute command in container:**
    ```bash
    docker exec -it <container-name> /bin/bash
    ```
    Examples:
    - WordPress: `docker exec -it wordpress /bin/bash`
    - MariaDB: `docker exec -it mariadb /bin/bash`
    - n8n: `docker exec -it n8n /bin/sh`

*   **Restart single service:**
    ```bash
    docker-compose -f src/docker-compose.yml restart <service-name>
    ```

*   **Scale a service:**
    ```bash
    docker-compose -f src/docker-compose.yml up -d --scale <service>=<count>
    ```

## 4. Data Persistence

Data is persisted using **Docker Volumes**. This ensures data survives container restarts and removals.

### Volume Overview

| Volume Name | Container Path | Purpose | Services Using |
|-------------|---------------|---------|----------------|
| `mariadb_data` | `/var/lib/mysql` | Database files | MariaDB |
| `web_data` | `/var/www/html` | WordPress files | WordPress, nginx, ftp_server |
| `n8n_data` | `/home/node/.n8n` | n8n workflows | n8n |

### Volume Details

1.  **Database Storage:**
    *   **Volume Name:** `mariadb_data`
    *   **Mount Path:** `/var/lib/mysql` (inside MariaDB container)
    *   **Description:** Stores all MariaDB database files, schemas, and user data. Even if the MariaDB container is destroyed, this volume retains all database content.
    *   **Backup:** To backup, copy the volume data or use `mysqldump`

2.  **Web Files:**
    *   **Volume Name:** `web_data`
    *   **Mount Path:** `/var/www/html` (inside WordPress, nginx, and FTP containers)
    *   **Description:** Stores WordPress core files, themes, plugins, and user uploads. Shared between:
        - WordPress container (read/write - writes files)
        - nginx container (read-only - serves static assets)
        - FTP server (read/write - allows file management)

3. **n8n Files:**
    *   **Volume Name:** `n8n_data`
    *   **Mount Path:** `/home/node/.n8n` (inside n8n container)
    *   **Description:** Stores n8n workflow definitions, credentials, execution history, and configurations. Essential for maintaining automation workflows across restarts.

### Host Location
`/home/<login>/data/` is the host directory where Docker volumes are stored. Each volume corresponds to a subdirectory within this path, allowing developers to access and manage data directly from the host machine if needed.

**Accessing volume data directly:**
```bash
# List volumes
docker volume ls

# Inspect volume
docker volume inspect <volume-name>

# Access on host (if using bind mounts)
ls /home/$USER/data/
```

### Data Backup and Restore

**Backup volumes:**
```bash
# Backup database volume
docker run --rm -v mariadb_data:/data -v $(pwd):/backup alpine tar czf /backup/mariadb_backup.tar.gz -C /data .

# Backup web files
docker run --rm -v web_data:/data -v $(pwd):/backup alpine tar czf /backup/web_backup.tar.gz -C /data .
```

**Restore volumes:**
```bash
# Restore database volume
docker run --rm -v mariadb_data:/data -v $(pwd):/backup alpine sh -c "cd /data && tar xzf /backup/mariadb_backup.tar.gz"

# Restore web files
docker run --rm -v web_data:/data -v $(pwd):/backup alpine sh -c "cd /data && tar xzf /backup/web_backup.tar.gz"
```
