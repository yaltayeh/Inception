# User Documentation

## What Services Are Provided

This stack provides the following services:

| Service | Purpose | Access |
|---------|---------|--------|
| **WordPress** | Main website/CMS | `https://<your-domain>` |
| **Adminer** | Database management UI | `https://adminer.<your-domain>` |
| **n8n** | Workflow automation | `https://n8n.<your-domain>` |
| **nextjs** | Next.js application | `https://nextjs.<your-domain>` |
| **MariaDB** | MySQL database | Port 3306 |
| **Redis** | Caching (internal) | No external access |
| **FTP Server** | SFTP file access | Port 2222 |
| **nginx** | Reverse proxy | Routes all HTTPS traffic |

## Quick Start Guide

Get the microservices lab running in 3 simple steps:

```bash
make config   # Set up configuration and secrets
make build    # Build Docker images
make          # Start all services
```

## Prerequisites

Before starting, ensure you have installed:

- **Docker Engine** - [Installation Guide](https://docs.docker.com/engine/install)
- **Docker Compose** - [Installation Guide](https://docs.docker.com/compose/install)
- **Make** - Usually pre-installed on Linux/Mac

## Installation Steps

### 1. Configure the Environment
Run the configuration script to generate required files:
```bash
make config
```
This creates:
- `src/.env` - Environment variables
- `secrets/` - Password files (kept secure)

### 2. Build Docker Images
Build all service images:
```bash
make build
```

### 3. Start Services
Launch all containers:
```bash
make
```

## Accessing Services

Once running, access your applications at:

| Service | URL/Port | Description |
|---------|----------|-------------|
| WordPress | `https://<your-domain>` | Main website (served by nginx) |
| Adminer | `https://adminer.<your-domain>` | Database management tool |
| n8n | `https://n8n.<your-domain>` | Workflow automation |
| nextjs | `https://nextjs.<your-domain>` | Next.js application |
| FTP Server | `<your-domain>:2222` | SFTP access to web files |

## Starting and Stopping the Project

### Start the Project
```bash
make
```
This builds (if needed) and starts all containers in detached mode.

### Stop the Project
```bash
make stop
```
Stops all running containers without removing them.

### Restart the Project
```bash
make clean && make
```
Stops, removes containers, and starts fresh.

### Full Cleanup (removes all data!)
```bash
make fclean
```
**Warning**: This removes containers, networks, volumes, and images. All data will be lost!

## Checking Service Health

### Check Running Containers
```bash
make ps
```
Shows all running containers and their status.

### View Service Logs
```bash
make logs
```
Shows real-time logs from all services.

### Check Individual Service
```bash
docker ps | grep <service-name>
```
Example: `docker ps | grep wordpress`

### Health Check Script
```bash
make status
```
Runs the health check script to verify all services are responding.

## Credentials and Access

### Where Credentials Are Stored

All credentials are generated during `make config` and stored in:

1. **`src/.env`** - Environment variables (domain, database names, usernames)
2. **`secrets/`** directory - Password files:
   - `wordpress_admin_password.txt` - WordPress admin password
   - `mysql_root_password.txt` - MariaDB root password
   - `mysql_user_password.txt` - MariaDB application user password
   - `ftp_password.txt` - FTP user password
   - `<your-domain>.key` and `<your-domain>.crt` - SSL certificates

### Default Usernames

| Service | Username | Where to Find Password |
|---------|----------|------------------------|
| WordPress Admin | `admin` (or as configured) | `secrets/wordpress_admin_password.txt` |
| MariaDB Root | `root` | `secrets/mysql_root_password.txt` |
| MariaDB User | `wordpress` (or as configured) | `secrets/mysql_user_password.txt` |
| FTP Server | `ftpuser` (or as configured) | `secrets/ftp_password.txt` |
| n8n | `admin` | Set in `src/.env` as `N8N_BASIC_AUTH_PASSWORD` |

### Accessing the Website and Admin Panels

**Main Website (WordPress):**
- URL: `https://<your-domain>`
- Admin: `https://<your-domain>/wp-admin`
- Login with WordPress admin credentials

**Database Management (Adminer):**
- URL: `https://adminer.<your-domain>`
- System: MySQL
- Server: `mariadb`
- Username: `wordpress` (or your configured user)
- Password: From `secrets/mysql_user_password.txt`
- Database: `wordpress` (or your configured database)

**Workflow Automation (n8n):**
- URL: `https://n8n.<your-domain>`
- Login with n8n basic auth credentials

## Data Storage

Your data is safely stored in Docker volumes:

- **Database**: `mariadb_data` - All MySQL/MariaDB data
- **Website Files**: `web_data` - WordPress files, themes, uploads (shared with nginx and FTP)
- **Workflows**: `n8n_data` - n8n workflows and credentials

Host location: `/home/<your-username>/data/`

## Service Details

### MariaDB (Database)
- **Port**: 3306 (exposed for external connections to `<your-domain>`)
- **Credentials**: Set during `make config`
- **Used by**: WordPress

### Redis
- **Internal service** - caching for WordPress
- No direct user access needed

### FTP Server
- **Port**: 2222 (SFTP to `<your-domain>`)
- **Access**: Connect with your configured FTP user/password
- **Files**: Direct access to web files in `/etc/www/html`

## Troubleshooting

### Services Won't Start?
```bash
make clean    # Stop and remove containers
make          # Start fresh
```

### Need to Reset Everything?
```bash
make fclean   # Removes containers, networks, volumes, and images
make config   # Reconfigure
make build    # Rebuild
make          # Start again
```

### Check What's Running?
```bash
make ps
```

### Access a Container Directly?
```bash
docker exec -it <container-name> /bin/bash
```
Examples:
- WordPress: `docker exec -it wordpress /bin/bash`
- MariaDB: `docker exec -it mariadb /bin/bash`

### Verify Services Are Healthy?
1. Check containers: `make ps`
2. Check logs: `make logs`
3. Run health check: `make status`
4. Test URLs in browser or with curl:
   ```bash
   curl -k https://<your-domain>
   curl -k https://adminer.<your-domain>
   curl -k https://n8n.<your-domain>
   ```

## Need Help?

- See [DEV_DOC.md](DEV_DOC.md) for developer documentation
- Visit [Docker Docs](https://docs.docker.com) for Docker help
- Check project [README.md](../README.md) for more resources
