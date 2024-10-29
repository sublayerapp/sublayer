require "base64"

require "sublayer"
require "octokit"

# Load all Sublayer Actions, Generators, and Agents
Dir[File.join(__dir__, "actions", "*.rb")].each { |file| require file }
Dir[File.join(__dir__, "generators", "*.rb")].each { |file| require file }
Dir[File.join(__dir__, "agents", "*.rb")].each { |file| require file }
Dir[File.join(__dir__, "providers", "*.rb")].each { |file| require file }

Sublayer.configuration.ai_provider = Sublayer::Providers::Gemini15Pro
Sublayer.configuration.ai_model = "gemini-1.5-pro-latest"

code_repo_path = "#{ENV['GITHUB_WORKSPACE']}/sublayer"
doc_repo_path = "#{ENV['GITHUB_WORKSPACE']}/sublayer_documentation"
pr_number = ENV['PR_NUMBER']
repo = ENV['GITHUB_REPOSITORY']

def with_retry(max_attempts = 5)
  attempts = 0
  begin
    yield
  rescue Net::ReadTimeout, JSON::ParserError, Sublayer::Providers::GeminiInternalServiceError => e
    attempts += 1
    if attempts < max_attempts
      puts "#{e.class.name} encountered. Retrying... (Attempt #{attempts} of #{max_attempts})"
      retry
    else
      puts "#{e.class.name} encountered. Max retries reached. Failing."
      raise e
    end
  end
end

puts "Getting pull request diff for PR ##{pr_number}"
diff = GithubGetDiffAction.new(repo: repo, pr_number: pr_number).call

puts "Getting Context"
code_context = GetContextAction.new(path: code_repo_path).call
doc_context = GetContextAction.new(path: doc_repo_path).call

doc_context.gsub!(/```(\w+)?\n/, '%%%\1\n').gsub!(/\n```/, "\n%%%")

puts "code context is #{code_context.size} long"
puts "doc context is #{doc_context.size} long"

result = nil
with_retry do
  result = DocUpdateNecessityGenerator.new(
    code_context: code_context,
    doc_context: doc_context,
    diff: diff
  ).generate
end

puts "need_doc_update: #{result.needs_update}, confidence: #{result.confidence}"

if result.needs_update.downcase == 'true' && result.confidence.to_f >= 0.7
  context_ignore_list = File.read("#{doc_repo_path}/.contextignore")
                            .split("\n")
                            .map(&:strip)
                            .reject { |line| line.empty? || line.start_with?("#") }
                            .join(", ")
  file_updates = nil
  with_retry(3) do
    doc_update_suggestions = nil
    puts "generating suggestions"
    with_retry(3) do
      doc_update_suggestions = DocUpdateSuggestionGenerator.new(
        code_context: code_context,
        doc_context: doc_context,
        context_ignore_list: context_ignore_list,
        diff: diff
      ).generate
    end

    suggestions = doc_update_suggestions.map {|suggestion| "#{suggestion.suggest}\n  description of file changes: \n  #{suggestion.file_changes}"}.join(", ")
    puts "here are suggestions:"
    puts suggestions

    puts "generating file contents"
    with_retry do
      file_updates = DocUpdateGenerator.new(
        code_context: code_context,
        suggestions: suggestions,
        doc_context: doc_context,
        context_ignore_list: context_ignore_list
      ).generate
    end
  end

  stamp = Time.now.strftime('%Y-%m-%d-%H-%M-%S')
  branch_name = "doc-updates-pr-#{pr_number}-#{stamp}"
  doc_repo_full_name = 'sublayerapp/sublayer_documentation'

  puts "Creating branch: #{branch_name}"
  GithubCreateBranchAction.new(
    repo: doc_repo_full_name,
    base_branch: "main",
    new_branch: branch_name
  ).call

  # Now write the file updates to disk
  file_updates.each do |file_update|
    file_path = file_update["file_path"]
    file_content = file_update["file_content"]

    puts "Updating file: #{file_path}"
    puts "file content: #{file_content}"

    GithubAddOrModifyFileAction.new(
      repo: doc_repo_full_name,
      branch: branch_name,
      file_path: file_path,
      file_content: file_content
    ).call
  end

  puts "Creating PR"
  GithubCreatePullRequestAction.new(
    repo: doc_repo_full_name,
    base: 'main',
    head: branch_name,
    title: "Doc Updates from Sublayer PR ##{@pr_number}",
    body: "This PR contains documentation updates based on changes in https://github.com/sublayerapp/sublayer/pull/#{@pr_number}."
  ).call
end