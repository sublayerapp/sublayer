class CreatePullRequestAction < Sublayer::Actions::Base
  def initialize(branch_name:, pr_number:)
    @branch_name = branch_name
    @pr_number = pr_number
  end

  def call
    client = Octokit::Client.new(access_token: ENV['ACCESS_TOKEN'])
    repo = 'sublayerapp/sublayer_documentation'
    base_branch = 'main'
    title = "Doc Updates from Sublayer PR ##{@pr_number}"
    body = "This PR contains documentation updates based on changes in https://github.com/sublayerapp/sublayer/pull/#{@pr_number}."

    client.create_pull_request(repo, base_branch, @branch_name, title, body)
  end
end
