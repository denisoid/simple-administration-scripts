#!/bin/bash

SITE=$1

#directories for virtual hosts
APACHE_VHOST_DIR=/etc/apache2/sites-enabled/
NGINX_VHOST_DIR=/etc/nginx/sites-enabled/


#path to virtual host templates
APACHE_VHOST=skel/apache2
NGINX_VHOST=skel/nginx


#copying and insert host name
cp $APACHE_VHOST $APACHE_VHOST_DIR$SITE;
sed -i 's/__host__/'$SITE'/g' $APACHE_VHOST_DIR$SITE


cp $NGINX_VHOST $NGINX_VHOST_DIR$SITE;
sed -i 's/__host__/'$SITE'/g' $NGINX_VHOST_DIR$SITE


#creating mysql username and password
MYSQLU=`echo $SITE | tr \.- __`
MYSQLP=`./gen_pass.sh`

#sql queries for creating database and grant access
MYSQL_QUERIES="CREATE DATABASE $MYSQLU;  GRANT  ALL PRIVILEGES ON $MYSQLU.* TO $MYSQLU@localhost IDENTIFIED BY '$MYSQLP';"


echo "Enter password for mysql";
echo $MYSQL_QUERIES | mysql -p ;


#creating  user
adduser $SITE --disabled-password --quiet --force-badname
mkdir /home/$SITE/public_html/
chown $SITE:$SITE /home/$SITE/public_html/

echo "User created!"
echo "Username: " $SITE
echo "MYSQL user: " $MYSQLU
echo "MYSQL database: "$MYSQLU
echo "MYSQL password: " $MYSQLP



#restart webserver
service apache2 graceful
service nginx reload

