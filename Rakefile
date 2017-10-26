require_relative "lib/somleng_project"
Dir.glob('lib/tasks/*.rake').each { |r| load r}

require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task :default => :spec
