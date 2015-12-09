desc 'Rebuilds development database, cleans compiled assets and runs all tests'
task :clean_test do
  Rake::Task["db:drop"].invoke
  Rake::Task["db:create"].invoke
  Rake::Task["migrate_all"].invoke
  Rake::Task["db:seed"].invoke
  Rake::Task["spec:coverage"].invoke
  Rake::Task["spec:javascript"].invoke
end
