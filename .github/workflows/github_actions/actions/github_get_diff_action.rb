class GithubGetDiffAction < GithubBase
  def initialize(repo:, pr_number:)
    super(repo: repo)
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