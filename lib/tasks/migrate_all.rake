desc 'Migrates both development and test database'
task :migrate_all do
  system("rake db:migrate RAILS_ENV=development")
  system("rake db:migrate RAILS_ENV=test")
end