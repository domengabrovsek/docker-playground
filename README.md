# docker-playground

Docker playground for learning and testing docker related stuff

## mysql-php-nginx

Contains docker-compose file to setup development environment for php applications using nginx + php + mysql with one command.

All files in the same folder as docker-compose.yml will be automatically visible inside nginx container and served in the same structure.

Setup:

```powershell
# get latest images and start containers
docker-compose pull
docker-compose up -d

# stop and remove containers
docker-compose down
```

When containers are running applications can be accessed:

- nginx
  - localhost
- mysql
  - db: root
  - user: root
  - password: root

## build-tag-deploy.ps1

Powershell script to automate build|tag|deploy of docker images.
