#!/bin/bash


# Check launch template
# cmd to start react app, API_URL should be given either Internal ALB dns or private ip of backend.
# docker run --rm -d -p 8443:80 -e API_URL="http://172.18.150.45:3003" my-react-app:v1 


# Check launch template file
#cmd to  start node js app, .env file should be created with DB instance private ip and frontend ALB's dns.
# docker run --rm -d -p 3003:3003 --env-file .env my-node-app:v1


# just in case, if want to take local docker0 ip
ifconfig docker0 | grep "inet " | awk '{print $2}'

ifconfig eth0 | grep "inet " | awk '{print $2}'