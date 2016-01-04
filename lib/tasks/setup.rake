desc 'Runs all the tests at local'
task :setup do
  sh "bundle update; bundle install; npm install"
end