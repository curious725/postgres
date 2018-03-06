#!/bin/bash

DB_ROOT_PASSWORD=$1
DB_NAME=$2
DB_USER=$3
DB_PASSWORD=$4
TEST_DB_NAME=$5
DJANGO_SETTINGS_MODULE=$6
PROJECT_REQUIREMENTS=$7
SERVER_NAME=$8
DB_HOST=$9
DB_PORT=$9

# fix possible locale issues
echo "# Locale settings
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8">>~/.bashrc
source ~/.bashrc

sudo locale-gen en_US.UTF-8
sudo dpkg-reconfigure --frontend=noninteractive locales



# #Updating and instaling dependencies
sudo apt-get update
sudo apt-get -y upgrade

# Ensure that we have a robust set-up for our programming environment
dpkg -s build-essential &>/dev/null || {
  sudo apt-get install -y build-essential
}

dpkg -s libssl-dev &>/dev/null || {
  sudo apt-get install -y libssl-dev
}

dpkg -s libffi-dev &>/dev/null || {
  sudo apt-get install -y libffi-dev
}

sudo add-apt-repository "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -sc)-pgdg main"
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
  sudo apt-key add -
sudo apt-get update
sudo apt-get install -y postgresql-9.6
sudo apt-get install -y postgresql-client-9.6
sudo apt-get install -y postgresql-contrib-9.6

touch ~/.pgpass
chmod 0600 ~/.pgpass
echo "$DB_HOST:$DB_PORT:*:postgres:$DB_ROOT_PASSWORD" >> ~/.pgpass
echo "$DB_HOST:$DB_PORT:$DB_NAME:$DB_USER:$DB_PASSWORD" >> ~/.pgpass

sudo -u postgres psql -c "CREATE DATABASE $DB_NAME";
