class GithubCreatePullRequestAction < Sublayer::Actions::Base
  def initialize(repo:, base:, head:, title:, body:)
    @client = Octokit::Client.new(access_token: ENV["ACCESS_TOKEN"])
    @repo = repo
    @base = base
    @head = head
    @title = title
    @body = body
  end

  def call
    @client.create_pull_request(@repo, @base, @head, @title, @body)
  end
end
