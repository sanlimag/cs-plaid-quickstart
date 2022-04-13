#!/bin/bash

echo 'Starting to Deploy...'
sudo docker image prune -f
cd quickstart
cp ../.env .
sudo docker-compose down
git fetch origin
git reset --hard origin/develop  &&  echo 'You are doing well'
sudo docker-compose build && sudo docker-compose up -d
echo 'Deployment completed successfully'