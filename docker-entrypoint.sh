#!/bin/bash
set -e
/docker-entrypoint-user.sh &
rabbitmq-server
