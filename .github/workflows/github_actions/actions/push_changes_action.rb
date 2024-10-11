class PushChangesAction < Sublayer::Actions::Base
  def initialize(repo_path:, commit_message:, branch_name:)
    @repo_path = repo_path
    @commit_message = commit_message
    @branch_name = branch_name
  end

  def call
    Dir.chdir(@repo_path) do
      `git config user.name "github-actions[bot]"`
      `git config user.email "github-actions[bot]@users.noreply.github.com"`

      `git add .`
      `git commit -m "#{@commit_message}"`

      remote_url = "https://x-access-token:#{ENV['ACCESS_TOKEN']}@github.com/sublayerapp/sublayer_documentation.git"
      `git remote set-url origin #{remote_url}`

      `git push origin #{@branch_name}`
    end
  end
end
