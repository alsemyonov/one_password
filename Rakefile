require 'bundler/gem_tasks'

begin
  require 'yard'
  YARD::Rake::YardocTask.new(:doc)
rescue LoadError
  task :doc do
    abort 'YARD is not available. In order to run yardoc, you must run: `bundle install``'
  end
end

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
  task :spec do
    abort 'RSpec is not available. In order to run specs, you must run: `bundle install`'
  end
end

task default: :spec
