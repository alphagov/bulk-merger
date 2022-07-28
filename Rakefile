require_relative "bulk_merger"

abort('abort: GITHUB_TOKEN not set in environment.') unless ENV['GITHUB_TOKEN']

desc "Confirm that you will release everything you merge"
task :confirm do
  required_confirmation = "I promise to release everything I merge"

  puts <<~CONFIRMATION
  Bulk merging pull requests should only be done if you're willing to ensure
  that every application is released to production.

  This is useful for things like security patches, which need to be merged
  across lots of applications quickly.

  However, in most cases it's more sensible to approve, merge, and release each
  application individually. This reduces the risk of having unreleased changes
  on the main branch.

  Please confirm that you understand this, and that you will release all the
  things you've merged by typing exactly:

  #{required_confirmation}

  CONFIRMATION

  confirmation = STDIN.gets.chomp

  if confirmation == required_confirmation
    puts "Okay then. You better do.\n"
  else
    abort "Please type exactly '#{required_confirmation}' to confirm"
  end
end

desc "Just approve pull requests"
task :review do
  BulkMerger.approve_unreviewed_pull_requests!
end

desc "Approve & merge pull requests"
task :merge => :confirm do
  BulkMerger.approve_unreviewed_pull_requests!
  BulkMerger.merge_approved_pull_requests!
end

desc "Merge approved pull requests, without reviewing"
task :merge_only => :confirm do
  BulkMerger.merge_approved_pull_requests!
end

desc "List un-reviewed pull requests"
task :list do
  BulkMerger.approve_unreviewed_pull_requests!(list: true)
end
