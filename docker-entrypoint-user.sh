#!/bin/bash

function try {
  while ! "$@"; do
    sleep 1
  done
}

try rabbitmqctl add_user "$FRONTEND_USER" "$FRONTEND_PASSWORD"
try rabbitmqctl add_user "$BACKEND_USER" "$BACKEND_PASSWORD"

try rabbitmqctl set_permissions "$FRONTEND_USER" '^$' '^$' '^dockci\.job\..+'
try rabbitmqctl set_permissions "$BACKEND_USER" dockci dockci dockci

try rabbitmqctl clear_password guest
