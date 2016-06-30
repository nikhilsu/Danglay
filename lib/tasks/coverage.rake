# frozen_string_literal: true
namespace :spec do
  desc 'Create rspec coverage without features'
  task :coverage do
    ENV['COVERAGE'] = 'true'
    Rake::Task['spec:without'].invoke('features')
  end
end
