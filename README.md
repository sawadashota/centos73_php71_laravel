# CentOS7 PHP7.1.x Laravel

## Installing
- PHP7.1.x
- Redis
- MySQL
- Laravel (The Newest Version)

## Before Starting
In this example, app container uses mysql container. So, please set it up before using this image.

```bash
$ docker pull mysql
$ docker pull busybox
$ docker run -v /var/lib/mysql --name mysql_data busybox
$ docker run --volumes-from mysql_data --name mysql -e MYSQL_ROOT_PASSWORD=mysql -d -p 3306:3306 mysql
```

## Getting Start
```bash
$ docker build -t laravel .
$ docker run --name NAME -h HOST_NAME --volumes-from mysql_data --link mysql:mysql -d -p PORT:80 -v PATH_TO_HOST_APP:/var/www/html/app --privileged laravel /sbin/init
```

Then, you can find app works at [http://localhost:PORT](http://localhost:PORT).

### Login to Container
```bash
$ docker exec -it NAME /bin/bash
```
