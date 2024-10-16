class GithubCreatePullRequestAction < GithubBase
  def initialize(repo:, base:, head:, title:, body:)
    super(repo: repo)
    @base = base
    @head = head
    @title = title
    @body = body
  end

  def call
    @client.create_pull_request(@repo, @base, @head, @title, @body)
  end
end
