#!/bin/bash
set -euo pipefail
git config --global user.name \"$GIT_USER\"
git config --global user.email \"$GIT_EMAIL\"
git config --global credential.helper 'store --file /root/.git-credentials'
echo "https://$GIT_USER:$GIT_TOKEN@github.com" > /root/.git-credentials
code-server --bind-addr 0.0.0.0:7000 --auth none /root/workspace
