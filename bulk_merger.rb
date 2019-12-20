require "octokit"

class BulkMerger
  def self.approve_unreviewed_pull_requests!(list: nil)
    puts "Searching for PRs containing '#{query_string}'"

    unreviewed_pull_requests = find_govuk_pull_requests("review:none #{query_string}")

    if unreviewed_pull_requests.size == 0
      puts "No unreviewed PRs found!"
      return
    end

    puts "Found #{unreviewed_pull_requests.size} unreviewed PRs:\n\n"

    unreviewed_pull_requests.each do |pr|
      puts "- '#{pr.title}' (#{pr.html_url}) "
    end

    return if list

    puts "\nHave you reviewed the changes, and you want to approve all these PRs? [y/N]\n"
    if STDIN.gets.chomp == "y"
      puts "OK! 👍 Approving away..."
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
    unmerged_pull_requests = find_govuk_pull_requests("review:approved #{query_string}")

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
      puts "OK! 👍 Merging away..."
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
    client.search_issues("#{query} archived:false is:pr user:#{user_name} state:open in:title").items
  end

  def self.govuk_repos

    search = "org:#{user_name}"

    if topic != "NONE"
      search += " topic:#{topic}"
    end

    @govuk_repos ||= client.search_repos(search)
      .items
      .reject!(&:archived)
      .map { |repo| repo.full_name }
  end

  def self.find_govuk_pull_requests(query)
    search_pull_requests(query).select do |pr|
      govuk_repos.any? { |repo| pr.repository_url.include?(repo) }
    end
  end

  def self.client
    @client ||= Octokit::Client.new(access_token: ENV.fetch("GITHUB_TOKEN"), auto_paginate: true)
  end

  def self.query_string
    ENV.fetch("QUERY_STRING")
  end

  def self.user_name
    ENV.fetch("GITHUB_USER", "alphagov")
  end

  def self.topic
    ENV.fetch("GITHUB_TOPIC", "govuk")
  end
end
