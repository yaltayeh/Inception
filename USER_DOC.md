# User Documentation (USER_DOC)

## 1. Services Provided
This stack deploys a complete web hosting environment consisting of:
*   **NGINX:** The entry point for the website. It acts as a secure web server (HTTPS) ensuring strictly TLSv1.2/1.3 connections.
*   **WordPress:** A popular Content Management System (CMS) running on php-fpm, allowing you to build and manage the website content.
*   **MariaDB:** The relational database management system that stores all the content and settings for WordPress.

## 2. Start and Stop the Project

### Starting
To start the entire infrastructure, run the following command from the root of the project directory:
```bash
make
```
This command will build the necessary Docker images if they don't exist and start the containers in the background.

### Stopping
To stop the running services:
```bash
make clean
```
To stop the services and remove all associated data (database content and website files), networks, and images:
```bash
make fclean
```

## 3. Access the Website and Administration Panel

### Website
Once the containers are up and running, you can access the WordPress website by opening your browser and navigating to:
**[https://yaltayeh.42.fr](https://yaltayeh.42.fr)**

*Note: You may encounter a security warning because the SSL certificate is self-signed. You will need to accept the risk/proceed to access the site.*

### Administration Panel
To manage the WordPress site (create posts, change themes, etc.), access the admin dashboard at:
**[https://yaltayeh.42.fr/wp-admin](https://yaltayeh.42.fr/wp-admin)**

Log in using the administrative credentials (Administrator username and password) defined in your configuration secrets.

## 4. Locate and Manage Credentials

The project uses a secure method for handling passwords called **Docker Secrets**.
*   **Location:** Credentials are not stored directly in the `docker-compose.yml` file. Instead, they are read from files located in the `secrets/` directory (created during setup).
*   **Environment Variables:** Non-sensitive configuration (like domain name, database user name) is stored in the `.env` file in the `src/` directory.

To change credentials (before the first launch), you would edit the respective text files in the `secrets/` folder.

## 5. Check Service Status

To verify that all services are running correctly:

1.  **List running containers:**
    ```bash
    docker ps
    ```
    You should see three containers listed: `nginx`, `wordpress`, and `mariadb`, all with a status of "Up".

2.  **View Logs:**
    If something isn't working, you can check the logs of a specific service (e.g., nginx):
    ```bash
    docker logs nginx
    ```
    Or see all logs:
    ```bash
    docker compose -f src/docker-compose.yml logs
    ```
