CPP : Connect
==========================================================

Quick Start
===========

Running CPP in a Vagrant VM is probably the quickest way to get up and running.

This sets up Ruby 1.9.3 on an Ubuntu 12.04 VM, based on [this guide](http://www.talkingquickly.co.uk/2014/06/rails-development-environment-with-vagrant-and-docker/)

1. Install [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
2. Install [Vagrant](https://www.vagrantup.com/downloads.html)
3. If you're on Linux, install nfsd
4. If you're on Windows, install git, and make sure the line endings are set to Unix (NOT CRLF)
5. Clone the git repo
6. In terminal, cd into the cpp directory and type 'vagrant up'
7. Wait forever while everything is downloaded and set up (if your internet cuts out during this step, something may go wrong and you may have to run this step again)
8. If this is your first time running the project, seed the db with the initial logins by typing './d seed-db' into the terminal (this command will not work on Windows)
9. You should be up and running! Visit http://localhost:3000 in your browser to see the site.
10. The vm is set up to mirror the files in the cpp directory, so you can change any files in there and watch the results update instantly on the site - no need to even restart.

Magic!

Rails ERD
---------
Allows you to view project entities in graphical form. [More Info](http://rails-erd.rubyforge.org/install.html)

* Install GraphViz with `brew install graphviz` or `sudo aptitude install graphviz`
* Run `rake erd` for a basic diagram
* For a full diagram w/ all bells and whistles, run `rake erd title='CPP Model Relationships' inheritance=true polymorphism=true orientation=vertical`
