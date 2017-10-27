#!/bin/bash

if [ "$*" == "" ]; then
  echo "*************** run following command to create virtual host ***************"
  echo "*  e.g.                                                                    *"
  echo "*  sudo ./vhost.sh <project_name>                                          *"
  echo "*  sudo ./vhost.sh helloworld                                              *"
  echo "*************** run following command to create virtual host ***************"
  echo "No arguments provided"
  exit 1
fi

name=$1
url=www.$1.local

#================= Create Directory Structure (This is as per your Server Configuration)
echo "Create directory structur for project $1:" && 
cd /var/www/ && 
sudo mkdir $1 && 
cd $1 && 
sudo mkdir devbox && 
cd devbox && 
sudo mkdir releases && 
sudo chown www-data:www-data -R releases && 
cd releases && 
sudo mkdir current && 
sudo chown vagrant:vagrant -R current && 
cd current && 
echo "Directory Structure Created!"
#================= Create Directory Structure

email=${3-'webmaster@localhost'}
sitesEnable='/etc/apache2/sites-enabled/'
sitesAvailable='/etc/apache2/sites-available/'
sitesAvailabledomain=$sitesAvailable$url.conf
sudo touch $sitesAvailabledomain
echo "Creating a vhost for $sitesAvailabledomain"
sudo sh -C "
    <VirtualHost *:80>
      ServerName $url
      ServerAlias backend.$1.local
      DocumentRoot /var/www/$1/devbox/releases/current/htdocs

      <Directory /var/www/$1/devbox/releases/current/htdocs>
        Options FollowSymLinks
        AllowOverride All
        Order allow,deny
        Allow from all
      </Directory>

      ErrorLog ${APACHE_LOG_DIR}/www.$1.local-error.log
      CustomLog ${APACHE_LOG_DIR}/www.$1.local-access.log combined
    </VirtualHost>" >> $sitesAvailabledomain
echo -e $"\nNew Virtual Host Created\n"
sudo sed -i "1s/^/127.0.0.1 $name\n/" /etc/hosts
sudo a2ensite $url
sudo service apache2 reload
echo "Done, please browse to http://$url to check!"

ls -l /etc/apache2/sites-available/
cd /var/www/$1/devbox/releases/current
echo "*************** Clone your Git project inside htdocs directory here ********"
echo "*  e.g.                                                                    *"
echo "*  git clone <project_url> .                                               *"
echo "*************** run following command to create virtual host ***************"
echo "*************** THANK YOU - ASHWIN PARMAR **********************************"
exit 1

