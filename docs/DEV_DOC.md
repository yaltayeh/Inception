# Developer Documentation (DEV_DOC)

## 1. Set Up the Environment

### Prerequisites
Ensure the development machine has the following installed:
*   **Git**
*   **Make**
*   **Docker Engine**
*   **Docker Compose**

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
```
This serves as the primary command for developers to spin up the stack.

## 3. Manage Containers and Volumes

### Container Management
*   **Stop containers:** 
    ``` sh
    make stop
    ```

*   **Restart containers:** 
    ``` sh
    make clean && make
    ```

*   **View live logs:** 
    ``` sh
    make logs
    ```

*   **Stop and remove all containers, networks, and volumes:**
    ``` sh
    make fclean
    ```

*   **Show running containers:**
    ``` sh
    make ps
    ```

*   **Execute command in container:**
    ``` sh
    docker exec -it wordpress /bin/bash
    ```

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

3. **n8n Files:**
    *   **Volume Name:** `n8n_data`
    *   **Mount Path:** `/home/node/.n8n` (inside n8n container)
    *   **Description:** Stores n8n workflow data, credentials, and configurations. This ensures that n8n retains its state across container restarts.


### Host Location
`/home/<login>/data/` is the host directory where Docker volumes are stored. Each volume corresponds to a subdirectory within this path, allowing developers to access and manage data directly from the host machine if needed.
