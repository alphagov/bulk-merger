require "octokit"

class BulkMerger
  def self.approve_unreviewed_pull_requests!
    puts "Searching for Dependabot PRs for gem '#{gem_name}'"

    unreviewed_pull_requests = find_govuk_pull_requests("review:none #{gem_name}")

    if unreviewed_pull_requests.size == 0
      puts "No unreviewed PRs found!"
      return
    end

    puts "Found #{unreviewed_pull_requests.size} unreviewed PRs:\n\n"

    unreviewed_pull_requests.each do |pr|
      puts "- '#{pr.title}' (#{pr.html_url}) "
    end

    puts "\nHave you reviewed the changes, and you want to approve all these PRs? [y/N]\n"
    if STDIN.gets.chomp == "y"
      puts "OK! Approving away..."
    else
      puts "👋"
      exit 1
    end

    unreviewed_pull_requests.each do |pr|
      print "Reviewing PR '#{pr.title}' (#{pr.html_url}) "

      repo = pr.repository_url.gsub("https://api.github.com/repos/", "")
      client.create_pull_request_review(repo, pr.number, event: "APPROVE")

      puts "✅"
    end
  end

  def self.merge_approved_pull_requests!
    unmerged_pull_requests = find_govuk_pull_requests("review:approved")

    if unmerged_pull_requests.size == 0
      puts "No unmerged PRs found!"
      return
    end

    puts "Found #{unmerged_pull_requests.size} reviewed but unmerged PRs:\n\n"

    unmerged_pull_requests.each do |pr|
      puts "- '#{pr.title}' (#{pr.html_url}) "
    end

    puts "\nHave you reviewed the changes, and you want to MERGE all these PRs? [y/N]\n"
    if STDIN.gets.chomp == "y"
      puts "OK! Approving away..."
    else
      puts "👋"
      exit 1
    end

    unmerged_pull_requests.each do |pr|
      print "Merging PR '#{pr.title}' (#{pr.html_url}) "

      repo = pr.repository_url.gsub("https://api.github.com/repos/", "")

      begin
        client.merge_pull_request(repo, pr.number)
        puts "✅"
      rescue Octokit::MethodNotAllowed => e
        puts "❌ Failed to merge: #{e.message.inspect}"
      end
    end
  end

  def self.search_pull_requests(query)
    client.search_issues("#{gem_name} archived:false is:pr user:alphagov state:open author:app/dependabot-preview in:title #{query}").items
  end

  def self.find_govuk_pull_requests(query)
    # Only search non-archived repos tagged with `govuk`.
    repos = client.search_repos("org:alphagov topic:govuk").items.reject!(&:archived)

    search_pull_requests(query).select do |pr|
      repos.any? { |repo| pr.repository_url.include?(repo.full_name) }
    end
  end

  def self.client
    @client ||= Octokit::Client.new(access_token: ENV.fetch("GITHUB_TOKEN"), auto_paginate: true)
  end

  def self.gem_name
    ENV.fetch("GEM_NAME")
  end
end
