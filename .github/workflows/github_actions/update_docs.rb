require "base64"

require "sublayer"
require "octokit"

# Load all Sublayer Actions, Generators, and Agents
Dir[File.join(__dir__, "actions", "*.rb")].each { |file| require file }
Dir[File.join(__dir__, "generators", "*.rb")].each { |file| require file }
Dir[File.join(__dir__, "agents", "*.rb")].each { |file| require file }

Sublayer.configuration.ai_provider = Sublayer::Providers::OpenAI
Sublayer.configuration.ai_model = "gpt-4o-2024-08-06"

code_repo_path = "#{ENV['GITHUB_WORKSPACE']}/sublayer"
doc_repo_path = "#{ENV['GITHUB_WORKSPACE']}/sublayer_documentation"
pr_number = ENV['PR_NUMBER']
repo = ENV['GITHUB_REPOSITORY']

puts "Getting pull request diff for PR ##{pr_number}"
diff = GithubGetDiffAction.new(repo: repo, pr_number: pr_number).call

puts "diff is: #{diff}"

puts "Getting Context"
code_context = GetContextAction.new(path: code_repo_path).call
doc_context = GetContextAction.new(path: doc_repo_path).call

puts "code context is #{code_context.size} long"
puts "doc context is #{doc_context.size} long"

result = DocUpdateNecessityGenerator.new(
  code_context: code_context,
  doc_context: doc_context,
  diff: diff
).generate

puts "need_doc_update:"
p result.needs_update
p result.confidence

if result.needs_update.downcase == 'true' && result.confidence.to_f >= 0.7
  context_ignore_list = File.read("#{doc_repo_path}/.contextignore").split("\n")
                                                                  .map(&:strip)
                                                                  .reject { |line| line.empty? || line.start_with?("#") }
                                                                  .join(", ")

  puts "generating suggestions"
  doc_update_suggestions = DocUpdateSuggestionGenerator.new(
    code_context: code_context,
    doc_context: doc_context,
    context_ignore_list: context_ignore_list,
    diff: diff
  ).generate

  puts "here are suggestions:"
  suggestions = doc_update_suggestions.map {|suggestion| "#{suggestion.suggest}\n  description of file changes: \n  #{suggestion.file_changes}"}.join(", ")
  puts suggestions

  file_updates = DocUpdateGenerator.new(
    code_context: code_context,
    suggestions: suggestions,
    doc_context: doc_context,
    context_ignore_list: context_ignore_list
  ).generate

  # Now write the file updates to disk
  file_updates.each do |file_update|
    file_path = file_update["file_path"]
    file_content = file_update["file_content"]

    puts "Updating file: #{file_path}"

    WriteFileAction.new(file_path: "#{doc_repo_path}/#{file_path}", file_contents: file_content).call
  end

  stamp = Time.now.strftime('%Y-%m-%d-%H-%M-%S')
  branch_name = "doc-updates-pr-#{pr_number}-#{stamp}"
  CreateLocalBranchAction.new(repo_path: doc_repo_path, branch_name: branch_name).call
  PushChangesAction.new(repo_path: doc_repo_path, commit_message: "Update docs based on PR ##{pr_number}", branch_name: branch_name).call

  GithubCreatePullRequestAction.new(
    repo: 'sublayerapp/sublayer_documentation',
    base: 'main',
    head: branch_name,
    title: "Doc Updates from Sublayer PR ##{@pr_number}",
    body: "This PR contains documentation updates based on changes in https://github.com/sublayerapp/sublayer/pull/#{@pr_number}."
  ).call
end