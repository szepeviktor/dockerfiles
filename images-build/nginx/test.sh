#!/usr/bin/env bash

# pull a PHP container to allow Ngnix to run
docker pull php:7.1-fpm-alpine

# spin up the required PHP container
running="$(docker ps -aq --filter="name=test_support_php")"
if [ "$running" == "" ]; then
	docker run --name test_support_php -v $(pwd)/tests/app:/var/www/html --rm -d php:7.1-fpm-alpine
fi

docker build -t nginx .

dgoss run --link test_support_php:php -v $(pwd)/tests/app:/var/www/html -p 8080:80 nginx 
dgoss run --link test_support_php:php -v $(pwd)/tests/app:/var/www/html -e VIRTUAL_HOST=foo.bar -p 8080:80 nginx 
dgoss run --link test_support_php:php -v $(pwd)/tests/app:/var/www/html -e VIRTUAL_HOST=localhost:8080 -p 8080:80 nginx 