desc 'Runs all the tests'
task :all_test => [:clean_test] do
  Rake::Task["spec:features"].invoke
end