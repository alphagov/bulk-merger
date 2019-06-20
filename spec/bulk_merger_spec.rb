require "spec_helper"
require 'webmock/rspec'
require_relative './../bulk_merger'

RSpec.describe BulkMerger do
  before do
    ENV["GITHUB_TOKEN"] = "fake-token"
    # Always say "yes" when asked
    expect(STDIN).to receive(:gets).and_return("y")
  end

  describe ".approve_unreviewed_pull_requests!" do
    it "approves unreviewed Pull Requests" do
      response = {
        items: [
          { title: "Update funky-gem to 12.0", html_url: "https://www.examples.org/some-url/123", number: "123", repository_url: "https://api.github.com/repos/alphagov/foo" },
          { title: "Update funky-gem to 12.0", html_url: "https://www.examples.org/some-url/321", number: "321", repository_url: "https://api.github.com/repos/alphagov/bar" },
        ]
      }

      stub_request(:get, "https://api.github.com/search/issues?per_page=100&q=funky-gem-to-merge%20archived:false%20is:pr%20user:alphagov%20state:open%20author:app/dependabot-preview%20in:title%20review:none%20funky-gem-to-merge").
        to_return(body: JSON.dump(response), headers: { 'Content-Type' => 'application/json' })

      ENV["GEM_NAME"] = "funky-gem-to-merge"

      @request_for_pr_1 = stub_request(:post, "https://api.github.com/repos/alphagov/foo/pulls/123/reviews").
        to_return(status: 200)
      @request_for_pr_2 = stub_request(:post, "https://api.github.com/repos/alphagov/bar/pulls/321/reviews").
        to_return(status: 200)

      expect {
        BulkMerger.approve_unreviewed_pull_requests!
      }.to output(/Reviewing PR 'Update funky-gem to 12.0'/).to_stdout

      expect(@request_for_pr_1).to have_been_requested
      expect(@request_for_pr_2).to have_been_requested
    end
  end

  describe ".merge_approved_pull_requests!" do
    it "merges approved Pull Requests" do
      response = {
        items: [
          { title: "Update funky-gem to 12.0", html_url: "https://www.examples.org/some-url/123", number: "123", repository_url: "https://api.github.com/repos/alphagov/foo" },
          { title: "Update funky-gem to 12.0", html_url: "https://www.examples.org/some-url/321", number: "321", repository_url: "https://api.github.com/repos/alphagov/bar" },
        ]
      }

      stub_request(:get, "https://api.github.com/search/issues?per_page=100&q=funky-gem-to-merge%20archived:false%20is:pr%20user:alphagov%20state:open%20author:app/dependabot-preview%20in:title%20review:approved").
        to_return(body: JSON.dump(response), headers: { 'Content-Type' => 'application/json' })

      ENV["GEM_NAME"] = "funky-gem-to-merge"

      @request_for_pr_1 = stub_request(:put, "https://api.github.com/repos/alphagov/foo/pulls/123/merge").
        to_return(status: 200)
      @request_for_pr_2 = stub_request(:put, "https://api.github.com/repos/alphagov/bar/pulls/321/merge").
        to_return(status: 200)

      expect {
        BulkMerger.merge_approved_pull_requests!
      }.to output(/Merging PR 'Update funky-gem to 12.0'/).to_stdout

      expect(@request_for_pr_1).to have_been_requested
      expect(@request_for_pr_2).to have_been_requested
    end
  end
end
