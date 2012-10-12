# Hackathon Template for Rails
A basic Rails app template for a hackathon project

Requirements
============

* I assume all teammembers are running OSX or Ubuntu (or some other Linux flavour). Windows users, You're on your own...)
* [Homebrew](http://mxcl.github.com/homebrew/) (OSX only)
* Git ``$ sudo apt-get install git``` or ``$ brew install git```
* RVM + Ruby 1.9.3
  * Install RVM ```curl -L https://get.rvm.io | bash -s stable```
  * Install Ruby 1.9.3 ```rvm install 1.9.2```
  * Set default ruby version ```rvm use 1.9.2 --default```


Useful tools
============

Sublime
-------
* Download [sublime] (http://www.sublimetext.com/2)
* Add Package manager
  * Visit [package manager](http://wbond.net/sublime_packages/package_control/installation) and copy the huge chunk of text
  * Press ctrl+(the plus/minus key thignn top left of keyboard), copy in the chunk and press enter
* Now install coffeescript package
  * cmd+shift+p
  * type install, enter
  * start typing coffeescript, enter
* Install git package
  * Same as Coffeescript but typing git
* Set default settings for 2 space indentation

Getting Started
===============

* Clone template locally ```$ git clone git@github.com:PeterHamilton/CPPRails.git```
* Remove git ```$ rm -rf .git``` in root
* Create new repo for hackathon
* Run ```$ bundle install``` in the root to get all the gems
* Run rails server ```$ rails s```
* Check rails is running by visiting [http://localhost:3000/](http://localhost:3000/) You should be able to see a static index.html file.