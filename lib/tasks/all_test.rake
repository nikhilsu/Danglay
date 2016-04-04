desc 'Runs all the tests at local'
task :all_test do
  ENV['COVERAGE'] = 'true'
  Rake::Task['db:drop'].invoke
  Rake::Task['db:create'].invoke
  Rake::Task['migrate_all'].invoke
  Rake::Task['db:seed'].invoke
  Rake::Task['spec'].invoke
  Rake::Task['spec:javascript'].invoke
  puts "\n\nChecking for vulnerabilities in gems...\n\n"
  system('bundle-audit check --update')
end