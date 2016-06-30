desc 'Runs all the tests at local'
task :all_test => [:turn_on_coverage, :set_test_env, 'db:drop', 'db:create', 'db:migrate', 'db:seed', :spec, 'spec:javascript'] do
  puts "\n\nChecking for vulnerabilities in gems...\n\n"
  system('bundle-audit check --update')
  puts "\n\nRunning metric_fu...\n\n"
  system('bundle exec metric_fu --no-open')
  puts "\n\nRunning brakeman...\n\n"
  system('bundle exec rake brakeman:run\[brakeman-report.html\]')
end

desc 'Rebuilds development database, cleans compiled assets and runs all tests'
task :clean_test => [:set_test_env, 'db:drop', 'db:create', 'db:migrate', 'db:seed', 'spec:coverage', 'spec:javascript']

task :turn_on_coverage do
  ENV['COVERAGE'] = 'true'
end

task :set_test_env do
  ENV['RAILS_ENV'] = 'test'
end
