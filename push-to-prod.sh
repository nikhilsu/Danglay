git push heroku master
heroku run bundle exec rake db:migrate
heroku logs > heroku_logs
