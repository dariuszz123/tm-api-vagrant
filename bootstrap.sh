sudo -s;

# hhvm repo
cd /etc/yum.repos.d;
sudo wget http://www.hop5.in/yum/el6/hop5.repo 
yum -y clean all;

# epel, remi
wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm;
wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm;
rpm -Uvh remi-release-6*.rpm epel-release-6*.rpm;

# config with enabled epel
rm /etc/yum.repos.d/remi.repo;
cp /bootstrap/etc/yum.repos.d/remi.repo /etc/yum.repos.d/remi.repo;

# base
yum -y install nano nginx hhvm couchdb;

# autostart
chkconfig --add hhvm;
chkconfig --add couchdb;

# hhvm pid
mkdir /var/run/hhvm;
touch /var/run/hhvm/pid;

# hhvm server config
rm /etc/hhvm/server.hdf;
cp /bootstrap/etc/hhvm/server.hdf /etc/hhvm/server.hdf;

# hhvm init.d script
rm /etc/rc.d/init.d/hhvm;
cp /bootstrap/etc/rc.d/init.d/hhvm /etc/rc.d/init.d/hhvm;
chmod g+x /etc/init.d/hhvm;

# nginx fastcgi
rm /etc/nginx/conf.d/default.conf;
cp /bootstrap/etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf;

# nginx config
rm /etc/nginx/nginx.conf;
cp /bootstrap/etc/nginx/nginx.conf /etc/nginx/nginx.conf;

# composer 
wget https://getcomposer.org/installer;
hhvm installer;
rm installer;
mv /home/vagrant/composer.phar /usr/bin/composer;

# hhvm php symlink
ln -s /usr/bin/hhvm /usr/bin/php;

# start services
service couchdb start;
service hhvm restart;
service nginx start;
