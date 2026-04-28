# Django + PostgreSQL + Nginx in Docker

This repository contains a minimal multi-service setup with:

- Django web application
- PostgreSQL database
- Nginx reverse proxy

## Run locally

1. Create the environment file:

   ```bash
   cp .env.example .env
   ```

2. Start the containers:

   ```bash
   docker-compose up -d --build
   ```

3. Open the application:

   - http://localhost

## Services

- `web` — Django application served by Gunicorn on port `8000`
- `db` — PostgreSQL database
- `nginx` — Reverse proxy exposed on port `80`

## Notes

- Nginx proxies requests to the Django container using the `django` network alias.
- Static files are collected into a shared Docker volume.
