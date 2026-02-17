# Developer Documentation (DEV_DOC)

## 1. Set Up the Environment

### Prerequisites
Ensure the development machine has the following installed:
*   **Git**
*   **Make**
*   **Docker Engine** (20.10.x or higher recommended)
*   **Docker Compose** (Plugin or standalone)

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

## 2. Build and Launch

The project uses a `Makefile` at the root for easy orchestration.

**Build images:**
To build the Docker images for NGINX, WordPress, and MariaDB without starting them:
```bash
make build
```

**Launch Project:**
To build (if changed) and start the containers in detached mode:
```bash
make
# OR
make up
```
This serves as the primary command for developers to spin up the stack.

## 3. Manage Containers and Volumes

### Container Management
*   **Stop containers:** `docker compose -f src/docker-compose.yml stop`
*   **Restart containers:** `docker compose -f src/docker-compose.yml restart`
*   **View live logs:** `docker compose -f src/docker-compose.yml logs -f`
*   **Execute command in container:**
    ```bash
    docker exec -it wordpress /bin/bash
    ```

### Volume Pruning
To completely wipe all persistent data (database and web files) to start fresh for testing:
```bash
make fclean
```
*Warning: This executes `docker system prune --all --force --volumes` (or similar cleanup commands via the script), effectively removing all stopped containers, unused networks, and **all volumes**.*

## 4. Data Persistence

Data is persisted using **Docker Volumes**.

1.  **Database Storage:**
    *   **Volume Name:** `mariadb_data`
    *   **Mount Path:** `/var/lib/mysql` (inside MariaDB container)
    *   **Description:** Stores all MariaDB database files. Even if the MariaDB container is destroyed, this volume retains the schema and data.

2.  **Web Files:**
    *   **Volume Name:** `web_data`
    *   **Mount Path:** `/var/www/html` (inside WordPress and NGINX containers)
    *   **Description:** Stores the WordPress core files, themes, plugins, and uploads. It is shared between the WordPress container (which writes files) and the NGINX container (which serves static assets).

### Host Location
On Linux systems, standard Docker volumes are typically located at `/var/lib/docker/volumes/`.
In this specific project configuration (if using bind mounts per typical subject requirements or custom override), they traditionally might be mapped to `~/data/mariadb` and `~/data/web` on the host machine to satisfy the curriculum's specific "Inception" rules regarding data location. 

*Check `src/docker-compose.yml` volume definitions to confirm if they are using the local driver pointing to specific host paths or standard managed volumes.*
