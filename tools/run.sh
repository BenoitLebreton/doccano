#!/usr/bin/env bash

set -o errexit

if [[ ! -d "app/staticfiles" ]]; then python app/manage.py collectstatic --noinput; fi

python app/manage.py wait_for_db
python app/manage.py migrate
python app/manage.py create_roles

for varname in ${!ADMIN_USERNAME*}
do
    # get suffix
    export suffix=${varname:14}
    # Ref to value username
    declare -n username=${varname/varname}
    # Ref to value corresponding password
    export passname=ADMIN_PASSWORD$suffix
    export password=${!passname}
    # Ref to corresponding email
    export emailname=ADMIN_EMAIL$suffix
    export email=${!emailname}

    echo $suffix
    echo $username
    echo $password
    echo $email
    if [[ -n "${username}" ]] && [[ -n "${email}" ]] && [[ -n "${password}" ]]; then
      python app/manage.py create_admin --noinput --username="${username}" --email="${email}" --password="${password}"
    fi
done






# if [[ -n "${ADMIN_USERNAME}" ]] && [[ -n "${ADMIN_EMAIL}" ]] && [[ -n "${ADMIN_PASSWORD}" ]]; then
#   python app/manage.py create_admin --noinput --username="${ADMIN_USERNAME}" --email="${ADMIN_EMAIL}" --password="${ADMIN_PASSWORD}"
# fi


# cd qm-labelling
# git init

# git config --global --unset credentials.helper
# git config --unset credential.helper
# git config credential.helper 'store --file ~/.git_repo_credentials'
# git config credential.helper store
# git config credential.*.username $GITLAB_USER



# git pull https://gitlab.com/quantmetry/qmtools/qm-labelling.git master
# cd qm-labelling
# bash init_demo.sh
#cd ~/doccano

gunicorn --bind="0.0.0.0:${PORT:-8000}" --workers="${WORKERS:-1}" --pythonpath=app app.wsgi --timeout 300


# sudo mkdir qm-labelling

# git config --global user.email "$GITLAB_USER"
# git config --global user.name "$GITLAB_USER"
# git config --global user.password "$GITLAB_PASSWORD"

# git config user.email "$GITLAB_USER"
# git config user.name "$GITLAB_USER"
# git config user.password "$GITLAB_PASSWORD"

# export GIT_ASKPASS=$GITLAB_PASSWORD