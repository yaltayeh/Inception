# User documentation

This file must explain, in clear and simple terms, how an end user or administrator can:

this project to setup wordpress, mariadb with nginx
work with docker compose

### how to run project

#### 1. Clone the Repository
```git clone https://github.com/your-username/your-repo-name.git```

#### 2. Navigate to the Project Directory
```cd your-repo-name/src```

#### 3. Environment setup
```
cp env.example .env
```
- Open the .env file and update the environment variables as needed, such as database credentials, WordPress admin username, and site title.

#### 4. Start the Project
```
docker-compose up -d
```

#### 5. Access the Website and Admin Panel
- Open your web browser and navigate to `https://yaltayeh.42.fr` to access the WordPress site.
- To access the WordPress admin panel, navigate to `https://yaltayeh.42.fr/wp-admin` and log in using the admin credentials you set in the .env file.
