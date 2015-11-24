git push prod master
heroku run bundle exec rake db:migrate -r prod
heroku logs -r prod > prod.log
