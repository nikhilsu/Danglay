[![Build Status](https://snap-ci.com/cHvYW_LvRxgkaNF41a-TLR8MxYsoqkJHayKumYgwxA0/build_image)](https://snap-ci.com/ThoughtWorksInc/danglay/branch/master)

README
======
# Problem Description:
  **Currently, a ThoughtWorker has to mail all of the city's ThoughtWorkers to be chosen as a cab mate by somebody. Although the current system in place is working, it can be made better by automating the process.**

  **Solution: A web application where in one can easily browse through and choose a list of cab mates to commute to and from the office based on the convenience of locality and route.**

# Environment
  **1. Postgres 9.4.5**

*    Mac OS X: https://github.com/PostgresApp/PostgresApp/releases
*    Ubuntu:Add the version of postgres you want from the repository by doing the given in Apt Repository http://www.postgresql.org/download/linux/ubuntu/
        >   $apt-get install postgresql

**2. Rbenv 0.4.0**

**3. Ruby 2.2.3**

**4. Rails 4.2.5**
* Follow the steps provided in the following link Mac OS X: https://gorails.com/setup/osx/10.10-yosemite.
* Ubuntu 12.04: https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-on-ubuntu-12-04-lts-precise-pangolin-with-rvm

# Building the application
  **Run the following commands to build the application.**

```bash
cd <path-to-project-directory>
bundle install
bundle exec rake all_test
```

## Running the application ##
**Run the following command to view the application in the browser.**

```bash
rails server
```

**Now you can view the application at `http://localhost:3000`**
