git push staging master
heroku run bundle exec rake db:migrate -r staging
heroku logs -r staging > staging.log
