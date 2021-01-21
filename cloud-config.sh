#!/bin/bash -x

# Reference: https://serverfault.com/questions/103501/how-can-i-fully-log-all-bash-scripts-actions
# Log everything
#
exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
exec 1>/var/log/cloud-config-detail.log 2>&1

wget https://gist.githubusercontent.com/jdmedeiros/1add075e054c911776d26e97a84dfdec/raw/62c0ccd0e8d76e0dc9d1b15fe369d101dd7bc12f/logger.sh
source ./logger.sh

SCRIPTENTRY
DEBUG "Script starting."

sudo apt-get update && sudo apt-get -y upgrade
INFO "System updated and upgraded."

sudo apt-get -y install apache2 mysql-server php libapache2-mod-php debconf-utils
INFO "Software packages installed."

cd /var/www

echo "<?php" >/tmp/info.php
echo "phpinfo();" >>/tmp/info.php
echo "?>" >>/tmp/info.php

sudo cp /tmp/info.php /var/www/html
rm /tmp/info.php
INFO "File info.php created at the Joomla and Moodle roots."

sudo systemctl restart apache2
INFO "Web sited created. Joomla on port 80 and Moodle on port 8080."

DEBUG "Script reached the end."
SCRIPTEXIT
