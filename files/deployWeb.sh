#!/bin/bash
#source settings.cfg
rootdbpass="$3";
# WEB host from web connect to db
host_web="$1";
hostdb="$2";
portdb=3306;
dbname="moodle";
moodleuser="$4";
moodlepassword="$5";
echo "Disable selinux"
sudo setenforce Permissive
echo "Update and install Apache and PHP";
        # sudo yum update -y;
        # sudo yum -y install mc;
        sudo yum install -y git;
        sudo yum install -y httpd;
        sudo echo "starting httpd";
        sudo systemctl start httpd.service;
        # To make sure if Apache server is running
        sudo systemctl status httpd;
        # Enable Apache to start on boot
        sudo systemctl enable httpd.service;
        # To install PHP 7.3 and its libraries:
        sudo yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm;
        sudo yum -y install epel-release yum-utils;
        sudo yum-config-manager --disable remi-php54;
        sudo yum-config-manager --enable remi-php73;
        sudo yum -y install php php-common php-intl php-zip php-soap php-xmlrpc php-opcache php-mbstring php-gd php-curl php-mysql php-xml;
        sudo systemctl restart httpd;
        sudo systemctl enable httpd.service
        sudo systemctl enable httpd

echo "Creating Moodle directories...";
sudo mkdir -p /var/moodle/data;
sudo chmod 0777 /var/moodle/data;
sudo chown -R apache:apache /var/moodle/data;
cd /var/www/html;
echo "Downloading Moodle";
sudo git clone -b MOODLE_36_STABLE git://git.moodle.org/moodle.git; 
echo "Installing Moodle cli mode"
# If cli will be not work in this appearance, than can be written in one line like: --lang="en" --wwwroot="http://moodle.local" --dataroot="/var/moodle/data" --dbtype="mariadb"...

sudo /usr/bin/php  moodle/admin/cli/install.php --lang="en" --wwwroot="http://$host_web/moodle" --dataroot="/var/moodle/data" --dbtype="mysqli" --dbhost="$hostdb" --dbname="$dbname" --dbuser="$moodleuser" --dbpass="$moodlepassword" --dbport="$portdb" --fullname="Moodle" --shortname="moodle" --adminuser="admin" --adminpass="$6" --adminemail="$7" --agree-license --non-interactive

sudo chmod 755 -R /var/www/html/moodle
# echo "Add alias : localhost moodle.local - to /etc/hosts";
# sudo echo "localhost" >> /etc/hosts;
# echo "add $host_web to etc/hosts";
# sudo echo "$host_web localhost ">> /etc/hosts;
echo "Restarting network and Apache...";
sudo systemctl restart network.service;
sudo systemctl restart httpd.service;

cat <<EOF
Service installed at $host_web
You will need to add a hosts file entry for:
moodle.local points to $hot_web
username: admin
password: $6
EOF

cat <<EOF > /etc/cron.d/moodle
* * * * * /usr/bin/php /var/www/moodle/html/moodle/admin/cli/cron.php
EOF

echo "Job Done!"
