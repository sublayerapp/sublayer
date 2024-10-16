class CreateLocalBranchAction < Sublayer::Actions::Base
  def initialize(repo_path:, branch_name:)
    @repo_path = repo_path
    @branch_name = branch_name
  end

  def call
    Dir.chdir(@repo_path) do
      system("git checkout -b #{@branch_name}")
    end
  end
end