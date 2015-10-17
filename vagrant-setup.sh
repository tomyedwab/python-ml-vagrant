#!/bin/sh

# Make a swapfile; some of this stuff requires more RAM than we've allocated

dd if=/dev/zero of=/swapfile bs=1024 count=1048576
chmod 0600 /swapfile
mkswap /swapfile
swapon /swapfile

# Add an APT repository for CRAN

echo "deb http://cran.ism.ac.jp/bin/linux/ubuntu trusty/" >> /etc/apt/sources.list
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys E084DAB9

# nom nom packages

apt-get update
apt-get upgrade -y
apt-get install -y python-pip python-dev pandoc \
    libfreetype6-dev pkg-config \
    r-base-core libzmq3-dev libcurl4-openssl-dev \
    texlive-latex-base texlive-latex-extra texlive-fonts-recommended

pip install -r /vagrant/requirements.txt

# Create a profile for iPython notebook

HOME=/home/vagrant sudo -u vagrant ipython profile create nbserver

# Configure the profile with a port (9123) and open IP access

echo """
c = get_config()

c.NotebookApp.ip = '*'
c.NotebookApp.open_browser = False
c.NotebookApp.port = 9123
""" > /home/vagrant/.ipython/profile_nbserver/ipython_notebook_config.py

chown vagrant:vagrant /home/vagrant/.ipython/profile_nbserver/ipython_notebook_config.py

# Create an upstart script to run the notebook

echo """
description "ipython"
 
start on runlevel [2345]
stop on runlevel [016]
respawn limit 10 5

env LANG=en_US.UTF-8
env LC_CTYPE=en_US.UTF-8

script
    cd /vagrant
    exec sudo -u vagrant ipython notebook --profile=nbserver --ipython-dir=/home/vagrant/.ipython/
end script
""" > /etc/init/ipython-notebook.conf

# R permissions

chown vagrant:vagrant /usr/local/lib/R/site-library

# Set up the R kernel

echo """
install.packages(c('rzmq','repr','IRkernel','IRdisplay','ggplot2', 'bigrquery', 'reshape'),
                 repos = c('http://irkernel.github.io/', 'http://cran.rstudio.com'),
                 type = 'source')
IRkernel::installspec()
""" | R --vanilla

# Fire it up!

start ipython-notebook
