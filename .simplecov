SimpleCov.minimum_coverage 90
SimpleCov.refuse_coverage_drop
SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
SimpleCov.start :rails do
  add_filter 'spec/'
  add_group 'Services', 'app/services'
  add_group 'Views', 'app/views'
end if ENV['COVERAGE']
