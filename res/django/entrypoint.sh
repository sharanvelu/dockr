#!/bin/bash

python manage.py runserver 0.0.0.0:5000

sleep 5

. /etc/entrypoint.sh
