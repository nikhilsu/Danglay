desc 'Installs cordova plugins for mobile'
task :install_plugins do
  sh "cd danglay-mobile; cordova plugin add cordova-plugin-splashscreen; cordova plugin add cordova-plugin-network-information;cd .."
end