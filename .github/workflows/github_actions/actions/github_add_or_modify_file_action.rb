class GithubAddOrModifyFileAction < Sublayer::Actions::Base
  def initialize(repo:, branch:, file_path:, file_content:)
    @client = Octokit::Client.new(access_token: ENV['ACCESS_TOKEN'])
    @repo = repo
    @branch = branch
    @file_path = file_path
    @file_content = file_content
  end

  def call
    content = @client.contents(@repo, path: @file_path, ref: @branch)
    @client.update_contents(
      @repo,
      @file_path,
      "Updating #{@file_path}",
      content.sha,
      @file_content,
      branch: @branch
    )
  end

  def call
    begin
      # Try to fetch the file contents to get its SHA
      content = @client.contents(@repo, path: @file_path, ref: @branch)

      # If the file exists, update it
      @client.update_contents(
        @repo,
        @file_path,
        "Updating #{@file_path}",
        content.sha,
        @file_content,
        branch: @branch
      )
      puts "File updated: #{@file_path}"
    rescue Octokit::NotFound
      # If the file does not exist, create it instead
      @client.create_contents(
        @repo,
        @file_path,
        "Creating #{@file_path}",
        @file_content,
        branch: @branch
      )
      puts "File created: #{@file_path}"
    end
  end
end