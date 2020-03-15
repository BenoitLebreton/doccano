#!/usr/bin/env bash

set -o errexit

if [[ ! -d "app/staticfiles" ]]; then python app/manage.py collectstatic --noinput; fi

python app/manage.py wait_for_db
python app/manage.py migrate
python app/manage.py create_roles

if [[ -n "${ADMIN_USERNAME}" ]] && [[ -n "${ADMIN_EMAIL}" ]] && [[ -n "${ADMIN_PASSWORD}" ]]; then
  python app/manage.py create_admin --noinput --username="${ADMIN_USERNAME}" --email="${ADMIN_EMAIL}" --password="${ADMIN_PASSWORD}"
fi

if [[ -n "${ADMIN_USERNAME2}" ]] && [[ -n "${ADMIN_EMAIL2}" ]] && [[ -n "${ADMIN_PASSWORD2}" ]]; then
  python app/manage.py create_admin --noinput --username="${ADMIN_USERNAME2}" --email="${ADMIN_EMAIL2}" --password="${ADMIN_PASSWORD2}"
fi

if [[ -n "${ADMIN_USERNAME3}" ]] && [[ -n "${ADMIN_EMAIL3}" ]] && [[ -n "${ADMIN_PASSWORD3}" ]]; then
  python app/manage.py create_admin --noinput --username="${ADMIN_USERNAME3}" --email="${ADMIN_EMAIL3}" --password="${ADMIN_PASSWORD3}"
fi

gunicorn --bind="0.0.0.0:${PORT:-8000}" --workers="${WORKERS:-1}" --pythonpath=app app.wsgi --timeout 300
#bash qm-labelling/init_demo.sh