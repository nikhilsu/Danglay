desc 'Runs all the tests at local'
task :setup do
  sh "bundle update"
  sh "bundle install"
  sh "npm install"
end