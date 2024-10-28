class GithubGetDiffAction < Sublayer::Actions::Base
  def initialize(repo:, pr_number:)
    @client = Octokit::Client.new(access_token: ENV['ACCESS_TOKEN'])
    @repo = repo
    @pr_number = pr_number
  end

  def call
    pr_files = @client.pull_request_files(@repo, @pr_number)
    pr_files.map do |file|
      {
        filename: file.filename,
        status: file.status,
        patch: file.patch
      }
    end
  end
end