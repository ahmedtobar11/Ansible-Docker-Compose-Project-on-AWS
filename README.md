# Ansible & Docker Compose Project on AWS

## 💡 Overview

This project automates the creation of AWS infrastructure using **Terraform**, installs **Docker** and **Docker-Compose** on an EC2 instance using **Ansible**, and deploys a WordPress and MySQL stack using **Docker-Compose**. The infrastructure includes a Virtual Private Cloud (VPC), a public subnet, and an EC2 instance (referred to as `docker_server`) where the services are deployed.

## 🗺️ Project Structure

-   **Terraform**: Used to define and provision the AWS infrastructure.
    
    -   VPC setup
    -   Public Subnet
    -   EC2 Instance (Docker Server)
-   **Ansible**: Automates the setup of Docker and Docker-Compose on the EC2 instance, ensures the services are running, and copies the `docker-compose.yaml` file to the instance.
    
-   **Docker-Compose**: Defines and runs a WordPress website with a MySQL database as the backend, all in Docker containers.
    
![Animation](https://github.com/user-attachments/assets/fff76792-71b5-43af-ac2a-915076813245)

----------

## 📈Project Workflow

### ☁️ Infrastructure Provisioning with Terraform

The Terraform configuration creates:

-   **VPC**: A Virtual Private Cloud to host the infrastructure.
-   **Public Subnet**: A public subnet within the VPC.
-   **EC2 Instance**: An Amazon Linux 2 instance (`docker_server`) which will host Docker services.

### 📖 Ansible Playbook for Docker Setup

The Ansible playbook performs the following tasks on the `docker_server` instance:

-   Install Docker and Docker-Compose.
-   Start and enable the Docker service.
-   Add the `ec2-user` to the Docker group.
-   Reset the SSH connection to apply group changes.
-   Copy the `docker-compose.yaml` file to the instance.
-   Start the services defined in `docker-compose.yaml`.

To run the Ansible playbook:
```
`ansible-playbook -i inventory.ini playbook.yml` 
```
### 🐳 Docker-Compose Deployment

Once Docker and Docker-Compose are installed, the Ansible playbook copies a `docker-compose.yaml` file to the EC2 instance, which defines two services: **WordPress** and **MySQL**.

#### MySQL Service

-   **MySQL**: A relational database that serves as the backend for WordPress.
-   The service is configured to store database files using a Docker volume to persist data across container restarts.
```
services:
  mysql_database:
    image: mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: 123
      MYSQL_DATABASE: wp_db
      MYSQL_USER: ahmed_tobar
      MYSQL_PASSWORD: 1234
    volumes:
      - db:/var/lib/mysql
```

-   **Image**: The `mysql` image is used to deploy the MySQL database.
-   **Environment variables**: Sets the database name (`wp_db`), user (`ahmed_tobar`), and password (`1234`) required by WordPress.
-   **Volumes**: Data is persisted using the `db` volume.

#### WordPress Service

-   **WordPress**: A content management system that connects to the MySQL database for storing data and serving content.
-   The service is exposed on port 8080 and connects to the MySQL service.

```
services:
  wordpress:
    image: wordpress
    restart: always
    ports:
      - 8080:80
    environment:
      WORDPRESS_DB_HOST: mysql_database
      WORDPRESS_DB_USER: ahmed_tobar
      WORDPRESS_DB_PASSWORD: 1234
      WORDPRESS_DB_NAME: wp_db
    volumes:
      - wordpress:/var/www/html
```

-   **Image**: The `wordpress` image is used to deploy the WordPress site.
-   **Ports**: Exposes the WordPress site on port 8080.
-   **Environment variables**: Connects to the MySQL database using the credentials defined earlier.
-   **Volumes**: Stores the WordPress content persistently in the `wordpress` volume.


To start both services together:
```
docker-compose -f docker-compose.yaml up -d
```

----------

## 🔎 Detailed Steps

### Step 1: Configure AWS Infrastructure with Terraform

1.  Define the VPC, subnet, and EC2 instance in the Terraform configuration files.
2.  Use Terraform to deploy the infrastructure:
    ```
    terraform init
    terraform apply
    ```
    

### Step 2: Deploy Docker & Docker-Compose with Ansible

1.  Ensure the EC2 instance's IP is added to the Ansible inventory file (`hosts`).
2.  Execute the Ansible playbook to install Docker and Docker-Compose, copy the Compose file, and start the services:
    ```
    ansible-playbook deploy-docker.yaml
    ```

###  Step 3: Running Docker-Compose Services

1.  The Ansible playbook copies the `docker-compose.yaml` file to `/home/ec2-user` on the EC2 instance.
2.  The playbook starts the Docker Compose stack, running both WordPress and MySQL services.
3.  You can access the WordPress site at `http://<EC2-instance-public-ip>:8080`.
----------

## Conclusion

This project demonstrates the complete automation of setting up a WordPress website and MySQL database on AWS using **Terraform**, **Ansible**, and **Docker-Compose**. By leveraging Infrastructure as Code (IaC) and configuration management tools, you can efficiently build and deploy scalable cloud solutions.
