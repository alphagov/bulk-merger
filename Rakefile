require_relative "bulk_merger"

desc "Just approve pull requests"
task :review do
  BulkMerger.approve_unreviewed_pull_requests!
end

desc "Approve & merge pull requests"
task :merge do
  BulkMerger.approve_unreviewed_pull_requests!
  BulkMerger.merge_approved_pull_requests!
end

desc "Merge approved pull requests, without reviewing"
task :merge_only do
  BulkMerger.merge_approved_pull_requests!
end
