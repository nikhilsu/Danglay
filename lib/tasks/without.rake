namespace :spec do

  desc 'Run all specs in spec directory without mentioned specs as args separated by comma and no spaces'
  RSpec::Core::RakeTask.new(:without, [:args]) do |task, args|
    file_list = FileList['spec/**/*_spec.rb']
    excludes = []
    excludes << args[:args]
    excludes << args.extras
    excludes.flatten!
    excludes.each do |exclude|
      file_list = file_list.exclude("spec/#{exclude.to_s}/**/*_spec.rb")
    end

    task.pattern = file_list
  end

end