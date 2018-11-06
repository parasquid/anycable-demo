#!/usr/bin/env bash
echo "Starting bootstrap"

sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger bionic main > /etc/apt/sources.list.d/passenger.list'
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7

apt-get update
apt-get upgrade -y

# Install nginx + passenger
apt install -y nginx
apt-get install -y dirmngr gnupg
apt-get install -y apt-transport-https ca-certificates
apt-get install -y libnginx-mod-http-passenger

if [ ! -f /etc/nginx/modules-enabled/50-mod-http-passenger.conf ]; then ln -s /usr/share/nginx/modules-available/mod-http-passenger.load /etc/nginx/modules-enabled/50-mod-http-passenger.conf ; fi
ls /etc/nginx/conf.d/mod-http-passenger.conf

service nginx restart

/usr/sbin/passenger-memory-stats

# Install Ruby + gem dependencies
apt install -y ruby build-essential patch ruby-dev zlib1g-dev liblzma-dev nodejs
gem install bundler --no-rdoc --no-ri

# Install yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
apt-get update && apt-get install yarn

# Install redis
apt install -y redis-server

# Setup the nginx/passenger site configuration
rm -f /etc/nginx/sites-enabled/app.conf
cat <<EOF >> /etc/nginx/sites-enabled/app.conf
server {
    listen 80;
    server_name localhost;

    # Tell Nginx and Passenger where your app's 'public' directory is
    root /var/www/app/current/public;

    # Turn on Passenger
    passenger_enabled on;
    passenger_ruby /usr/bin/ruby;

    location /cable {
        passenger_app_group_name app_action_cable;
        passenger_force_max_concurrent_requests_per_process 0;
    }

    # Specific to Vagrant environment
    passenger_app_env vagrant;
    passenger_intercept_errors on;
    passenger_friendly_error_pages on;

    passenger_env_var DATABASE_PASSWORD vagrant;
}
EOF

# Install postgres
apt install -y libpq-dev

# Install libraries
apt install -y postgresql postgresql-contrib

# Setup postgres
sudo -u postgres bash -c "psql -c \"CREATE ROLE vagrant WITH LOGIN SUPERUSER PASSWORD 'vagrant';\""
sudo -u postgres bash -c "psql -c \"CREATE DATABASE vagrant;\""

# Setup environment variables
echo "DATABASE_PASSWORD=vagrant" >> /etc/environment
echo "RAILS_ENV=vagrant" >> /etc/environment
echo "RACK_ENV=vagrant" >> /etc/environment

# Copies the master.key file to the VM
mkdir -p /var/www/app/shared/config
ln -s /vagrant/master.key /var/www/app/shared/config/master.key

# Make sure the deployment folder is writable
chown -R vagrant: /var/www

echo "bootstrap done, rebooting ..."
reboot

