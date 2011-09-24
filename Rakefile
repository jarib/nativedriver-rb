require 'bundler/gem_tasks'

require 'rspec/core/rake_task'

namespace :spec do
  desc 'Run Android specs'
  RSpec::Core::RakeTask.new(:android) do |t|
    t.pattern = 'spec/android/**/*_spec.rb'
  end

  desc 'Run iOS specs'
  RSpec::Core::RakeTask.new(:ios) do |t|
    t.pattern = 'spec/ios/**/*_spec.rb'
  end
end