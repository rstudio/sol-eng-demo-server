#!/bin/bash

set -e
set -x

# touch log files to initialize them
mkdir -p /var/lib/rstudio-launcher
chown rstudio-server:rstudio-server /var/lib/rstudio-launcher
su rstudio-server -c 'touch /var/lib/rstudio-launcher/rstudio-launcher.log'
touch /var/log/rstudio-server.log
mkdir -p /var/lib/rstudio-launcher/Local
chown rstudio-server:rstudio-server /var/lib/rstudio-launcher/Local
su rstudio-server -c 'touch /var/lib/rstudio-launcher/Local/rstudio-local-launcher-placeholder.log'
mkdir -p /var/lib/rstudio-launcher/Kubernetes
chown rstudio-server:rstudio-server /var/lib/rstudio-launcher/Kubernetes
su rstudio-server -c 'touch /var/lib/rstudio-launcher/Kubernetes/rstudio-kubernetes-launcher.log'

# handled in rstudio-workbench startup
# # Create one user
# if [ $(getent passwd $RSP_TESTUSER_UID) ] ; then
#     echo "UID $RSP_TESTUSER_UID already exists, not creating $RSP_TESTUSER test user";
# else
#     if [ -z "$RSP_TESTUSER" ]; then
#         echo "Empty 'RSP_TESTUSER' variables, not creating test user";
#     else
#         useradd -m -s /bin/bash -N -u $RSP_TESTUSER_UID $RSP_TESTUSER
#         echo "$RSP_TESTUSER:$RSP_TESTUSER_PASSWD" | sudo chpasswd
#     fi
# fi

tail -n 100 -f \
  /var/lib/rstudio-launcher/*.log \
  /var/lib/rstudio-launcher/Local/*.log \
  /var/lib/rstudio-launcher/Kubernetes/*.log &

# the main container process
# cannot use exec or we lose the "tail" running in the background
/usr/lib/rstudio-server/bin/rstudio-launcher
