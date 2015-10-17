# python-ml-vagrant
Vagrant configuration for running an IPython notebook server for machine learning.

Clone this repository locally and then from the command line run "vagrant up" and you're good to go. If you need anything else you can open a console with "vagrant ssh" and run "sudo pip install X", where X is the Python package you need.

Once it's all set up (it takes a while) you should be able to go to "localhost:9123" in your browser and see all the files in this directory in your IPython notebook.

Dependencies
============

[Vagrant](https://www.vagrantup.com/)
[VirtualBox](https://www.virtualbox.org/wiki/Downloads) (or VMWare, or [whatever](https://docs.vagrantup.com/v2/getting-started/providers.html))