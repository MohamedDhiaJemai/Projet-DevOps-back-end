#!/bin/bash
host="$1"
shift
until mysql -h"$host" -u"$DB_USER" -p"$DB_PASSWORD" -e "show databases"; do
  echo "Waiting for MySQL to be ready..."
  sleep 3
done
echo "MySQL is ready!"
exec "$@"
