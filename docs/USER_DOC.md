# User Documentation

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

## Daily Usage Commands

### Check Service Status
```bash
make status
```

### View Logs
```bash
make logs
```

### Stop Services
```bash
make stop
```

### Restart Services
```bash
make clean && make
```

### Full Cleanup (removes data too!)
```bash
make fclean
```

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

**Services won't start?**
```bash
make clean    # Stop and remove containers
make          # Start fresh
```

**Need to reset everything?**
```bash
make fclean   # Removes containers, networks, volumes, and images
make config   # Reconfigure
make build    # Rebuild
make          # Start again
```

**Check what's running:**
```bash
make ps
```

**Access a container directly:**
```bash
docker exec -it wordpress /bin/bash
```

## Need Help?

- See [DEV_DOC.md](DEV_DOC.md) for developer documentation
- Visit [Docker Docs](https://docs.docker.com) for Docker help
- Check project [README.md](../README.md) for more resources
