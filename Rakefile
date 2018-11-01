require_relative "bulk_merger"

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

task :default => [:spec]

desc "Just approve pull requests"
task :review do
  BulkMerger.approve_unreviewed_pull_requests!
end

desc "Approve & merge pull requests"
task :merge do
  BulkMerger.approve_unreviewed_pull_requests!
  BulkMerger.merge_approved_pull_requests!
end
