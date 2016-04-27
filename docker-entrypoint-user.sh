#!/bin/bash

set -x

function try {
  while [[ $(awk '$2 ~ /:(6448|3D38|3D3A)/{print}' < /proc/net/tcp | wc -l) < 3 ]]; do
    sleep 1
  done
  while ! "$@"; do
    sleep 1
  done
}

fe_count=$((try rabbitmqctl -t 1 list_users) | grep "$FRONTEND_USER" | wc -l)
be_count=$((try rabbitmqctl -t 1 list_users) | grep "$BACKEND_USER" | wc -l)
mo_count=$((try rabbitmqctl -t 1 list_users) | grep "$MONITOR_USER" | wc -l)

[[ $fe_count == '0' ]] && rabbitmqctl add_user "$FRONTEND_USER" "$FRONTEND_PASSWORD"
[[ $be_count == '0' ]] && rabbitmqctl add_user "$BACKEND_USER" "$BACKEND_PASSWORD"
[[ $mo_count == '0' ]] && rabbitmqctl add_user "$MONITOR_USER" "$MONITOR_PASSWORD"

rabbitmqctl set_permissions "$BACKEND_USER" dockci dockci dockci
rabbitmqctl set_permissions "$FRONTEND_USER" '^$' '^$' '^dockci\.job\..+'
rabbitmqctl set_permissions "$MONITOR_USER" '^$' '^$' '^aliveness_test$'
rabbitmqctl set_user_tags "$MONITOR_USER" 'monitoring'

try rabbitmqctl clear_password guest
