#!/usr/bin/env bash

log () {
    msg=$1
    echo "[$(date '+%d-%m-%Y %H:%M:%S')] $msg"
}

apt-get update
DEBIAN_FRONTEND=noninteractive apt-get -yq install python3.8-venv

[[ -f /etc/profile.d/python-venv.sh ]] || { echo "python venv profile missing"; exit 1; }
. /etc/profile.d/python-venv.sh

mkvenv salt
pip install salt
deactivate

git clone https://github.com/ygersie/salt.git /srv/salt
chmod 750 /srv/salt

count=1
while [[ ${count} -le 3 ]]; do
    if /usr/local/bin/salt-apply 2>&1 | egrep -q 'Failed:\s+0'; then
        log "Performed successful salt-call run #${count}.."
        (( count++ ))
    fi
done
log "Finished 3 successful salt-call runs"
