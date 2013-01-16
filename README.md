CPP 2.0
=======

Revolutionising the Corporate Partnership Programme

Quick-Start
===========

1. Install Rails, ImageMagick and Redis
2. Clone the repository & cd into it
3. Run `bundle install` to install the necessary gems
4. Run `rake nuke` to set up a seeded development database
5. Fire up a dev app with `rails s`
6. Visit `localhost:3000` in your browser
7. Use app! See `db/seeds.rb` to find logins for students/companies/dept admins

Further Requirements/Team Setup
==========================

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
* Set default settings for 2 space indentation, no line wrap, 80+120 line guides (rulers)

Rails ERD
---------
Allows you to view project entities in graphical form. [More Info](http://rails-erd.rubyforge.org/install.html)

* Install GraphViz with `brew install graphviz` or `sudo aptitude install graphviz`
* Run `rake erd` for a basic diagram
* For a full diagram w/ all bells and whistles, run `rake erd title='CPP Model Relationships' inheritance=true polymorphism=true orientation=vertical`


Getting Started
===============

* Clone template locally ```$ git clone git@github.com:PeterHamilton/cpp.git```
* Run ```$ bundle install``` in the root to get all the gems
* Run rails server ```$ rails s```
* Check rails is running by visiting [http://localhost:3000/](http://localhost:3000/)
