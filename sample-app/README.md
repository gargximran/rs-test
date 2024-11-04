
# Node.js PostgreSQL Connection App

This is a simple Node.js application that demonstrates how to connect to a PostgreSQL database using the `pg` library. The application is structured to run in a Docker container.

## Features

- Connects to a PostgreSQL database
- Basic route to test the connection
- Built using Express.js and PostgreSQL

## Requirements

- [Docker](https://www.docker.com/get-started) installed on your machine
- A PostgreSQL database accessible from the Docker container

## Environment Variables

Before running the application, make sure to set the following environment variables:

- `DB_USER`: The username to connect to the database
- `DB_HOST`: The host of the database (e.g., `localhost` or an IP address)
- `DB_NAME`: The name of the database
- `DB_PASSWORD`: The password for the database user
- `DB_PORT`: The port the database is listening on (default is `5432`)

## Getting Started

1. **Clone the repository:**

   ```bash
   git clone git@github.com:gargximran/rs-test.git
   cd rs-test/sample-app
   ```

2. **Build the Docker image:**

   ```bash
   docker build -t node-postgres-app .
   ```

3. **Run the Docker container:**

   You can run the container with the environment variables using the `-e` flag. For example:

   ```bash
   docker run -p 3000:3000 \
       -e DB_USER=<your_db_user> \
       -e DB_HOST=<your_db_host> \
       -e DB_NAME=<your_db_name> \
       -e DB_PASSWORD=<your_db_password> \
       -e DB_PORT=<your_db_port> \
       node-postgres-app
   ```

4. **Access the application:**

   Open your browser and go to `http://localhost:3000`. You should see the message `Database connection test`.

## Docker Commands

- **List Docker images:**

  ```bash
  docker images
  ```

- **Stop a running container:**

  ```bash
  docker stop <container_id>
  ```

- **Remove a Docker container:**

  ```bash
  docker rm <container_id>
  ```

