class GetDiffAction < Sublayer::Actions::Base
  def initialize(repo:, pr_number:)
    @repo = repo
    @pr_number = pr_number
  end

  def call
    client = Octokit::Client.new(access_token: ENV['ACCESS_TOKEN'])
    pr_files = client.pull_request_files(@repo, @pr_number)
    pr_files.map do |file|
      {
        filename: file.filename,
        status: file.status,
        patch: file.patch
      }
    end
  end
end