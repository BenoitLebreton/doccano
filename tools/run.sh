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


# cd qm-labelling
# git init

# git config --global --unset credentials.helper
# git config --unset credential.helper
# git config credential.helper 'store --file ~/.git_repo_credentials'
# git config credential.helper store
# git config credential.*.username $GITLAB_USER



# git pull https://gitlab.com/quantmetry/qmtools/qm-labelling.git master
cd qm-labelling
bash init_demo.sh

cd ~/doccano
gunicorn --bind="0.0.0.0:${PORT:-8000}" --workers="${WORKERS:-1}" --pythonpath=app app.wsgi --timeout 300


# sudo mkdir qm-labelling

# git config --global user.email "$GITLAB_USER"
# git config --global user.name "$GITLAB_USER"
# git config --global user.password "$GITLAB_PASSWORD"

# git config user.email "$GITLAB_USER"
# git config user.name "$GITLAB_USER"
# git config user.password "$GITLAB_PASSWORD"

# export GIT_ASKPASS=$GITLAB_PASSWORD