# CPP 2.0
Revolutionising the Corporate Partnership Programme

Requirements
============

* Assuming all teammembers are running OSX or Ubuntu...
* (OSX only) Install [Homebrew](http://mxcl.github.com/homebrew/)
* Install Git ``$ sudo apt-get install git``` or ``$ brew install git```
* On Ubuntu you may need to run ``sudo apt-get install build-essential openssl libreadline6 libreadline6-dev curl git-core zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev ncurses-dev automake libtool bison subversion pkg-config``
* Install RVM: run ``\curl -L https://get.rvm.io | bash -s stable --rails`` - more info: [RVM with Ruby](https://rvm.io/rvm/install/)


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
* Install scss package (for Super CSS)
  * Same as Coffeescript but typing scss
* Set default settings for 2 space indentation, no line wrap, 80+120 line guides

Getting Started
===============

* Clone template locally ```$ git clone git@github.com:PeterHamilton/cpp.git```
* Run ```$ bundle install``` in the root to get all the gems
* Run rails server ```$ rails s```
* Check rails is running by visiting [http://localhost:3000/](http://localhost:3000/)