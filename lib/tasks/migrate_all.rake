desc 'Migrates both development and test database'
task :migrate_all do
  Rake::Task["db:migrate"].invoke("RAILS_ENV=development")
  Rake::Task["db:migrate"].invoke("RAILS_ENV=test")
end