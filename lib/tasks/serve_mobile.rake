# frozen_string_literal: true
desc 'Serves for mobile'
task :serve_mobile do
  sh 'cd danglay-mobile; cordova emulate ios; cd ..'
end
