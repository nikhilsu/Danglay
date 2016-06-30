# frozen_string_literal: true
# Overriding the default task with one that accepts the output file
# Can be invoked as: rake bundler:audit\[bundler-audit-report.html\]
namespace :bundler do
  desc 'Run bundler-audit'
  task :audit, :output_files do |_t, args|
    require 'bundler/audit/cli'

    Bundler::Audit::CLI.start ['update']

    files = args[:output_files].split(' ') if args[:output_files]
    output_file_name = files.blank? ? 'bundler-audit-report.html' : files.first
    Bundler::Audit::CLI.start ['check', "-o=#{output_file_name}"]
  end
end

task default: 'bundler:audit'
