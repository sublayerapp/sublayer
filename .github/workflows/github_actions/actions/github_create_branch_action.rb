class GithubCreateBranchAction
  def initialize(repo:, base_branch:, new_branch:)
    @client = Octokit::Client.new(access_token: ENV['ACCESS_TOKEN'])
    @repo = repo
    @base_branch = base_branch
    @new_branch = new_branch
  end

  def call
    ref = @client.ref(@repo, "heads/#{@base_branch}")
    @client.create_ref(@repo, "refs/heads/#{@new_branch}", ref.object.sha)
  end
end