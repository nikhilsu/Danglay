README
======
# Problem Description:
  **Currently, a ThoughtWorker has to mail all of the city's ThoughtWorkers to be chosen as a cab mate by somebody. Although the current system in place is working, it can be made better by automating the process.**

  **Solution: A web application where in one can easily browse through and choose a list of cab mates to commute to and from the office based on the convenience of locality and route.**

# Environment
  **1. Postgres 9.4.5**

*    Mac OS X: https://github.com/PostgresApp/PostgresApp/releases
    Ubuntu:Add the version of postgres you want from the repository by doing the given in Apt Repository http://www.postgresql.org/download/linux/ubuntu/
        >   $apt-get install postgresql

**2. Rbenv 0.4.0** 

**3. Ruby 2.2.3**

**4. Rails 4.2.5**
* Follow the steps provided in the following link Mac OS X: https://gorails.com/setup/osx/10.10-yosemite.
* Ubuntu 12.04: https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-on-ubuntu-12-04-lts-precise-pangolin-with-rvm

# Before Building
**Clone and follow instructions in the given README.md for the following repositories.**
* To view the go server
    > https://github.com/nikhilsu/ip
* To initialize okta meta data
    > https://github.com/nikhilsu/meta
# Building the application
  **Run the following commands to build the application.**

* $cd <path-to-project-directory>
* $bundle update
* $bundle install
* $bundle exec rake all_test

## Running the application ##
**Run the following command to view the application in the browser.**

* $rails server

**Now you can view the application at localhost:3000**

## Building for mobile
  * Install node and run the command `npm install -g cordova`
  * Install xcode and android sdk
  * Go to path/to/project_folder/`danglay-mobile` run `cordova platform add ios` and `cordova platform add android`
  * To build the project for mobile, run `rake build_mobile`
  * To serve the project on mobile, run `rake serve_mobile`
