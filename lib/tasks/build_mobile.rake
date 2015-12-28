desc 'Builds for mobile'
task :build_mobile do
  # add task for src files copying to cordova www folder
  sh "cd danglay-mobile; cordova build ios; cd .."
end