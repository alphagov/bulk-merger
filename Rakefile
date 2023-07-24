require_relative "bulk_merger"

abort('abort: GITHUB_TOKEN not set in environment.') unless ENV['GITHUB_TOKEN']

desc "Warn user about releasing gems and k8s deployments"
task :warning do

  puts <<~WARNING
  ⚠️ WARNING ⚠️

  You are about to run a script that will bulk-merge pull requests. Please be aware of the following:

  Releasing gems is a manual process. Ensure you are familiar with the process before proceeding.
  Refer to the official documentation for detailed instructions: https://docs.publishing.service.gov.uk/manual/publishing-a-ruby-gem.html

  Merging pull requests will trigger automatic deployment of the apps in Kubernetes.
  Make sure you understand the deployment process and how to manage your apps in the Kubernetes environment.
  See https://govuk-kubernetes-cluster-user-docs.publishing.service.gov.uk/manage-app/access-ci-cd/

  Proceed with caution. If you are unsure about any part of this process, consult with your team or seek help from GOV.UK developers.
  WARNING
end

desc "Just approve pull requests"
task :review do
  BulkMerger.approve_unreviewed_pull_requests!
end

desc "Approve & merge pull requests"
task :merge => :warning do
  BulkMerger.approve_unreviewed_pull_requests!
  BulkMerger.merge_approved_pull_requests!
end

desc "Merge approved pull requests, without reviewing"
task :merge_only => :warning do
  BulkMerger.merge_approved_pull_requests!
end

desc "List un-reviewed pull requests"
task :list do
  BulkMerger.approve_unreviewed_pull_requests!(list: true)
end
