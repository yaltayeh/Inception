# User documentation

This file must explain, in clear and simple terms, how an end user or administrator can:

this project to setup wordpress, mariadb with nginx
work with docker compose

### how to run project

#### 1. Clone the Repository
```git clone https://github.com/yaltayeh/Inception.git```

#### 2. Navigate to the Project Directory
```cd Inception```

#### 3. Configure project settings
``` 
make config

# This will create a .env file with default values. You can edit this file to customize your setup, such as setting the DOMAIN_NAME, database credentials, and admin credentials for WordPress.
```


#### 4. Start the Project
```
echo "127.0.0.1 yaltayeh.42.fr" | sudo tee -a /etc/hosts

make build

make

```

#### 5. Access the Website and Admin Panel
- Open your web browser and navigate to `https://yaltayeh.42.fr` to access the WordPress site.
- To access the WordPress admin panel, navigate to `https://yaltayeh.42.fr/wp-admin` and log in using the admin credentials you set in the .env file.

#### 6. Stop the Project
```
docker-compose down
```
