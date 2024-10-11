class DocUpdateGenerator < Sublayer::Generators::Base
  TEMPLATE_CONTENT = File.read(File.join(__dir__, 'just_the_docs_template.md'))

  llm_output_adapter type: :list_of_named_strings,
    name: "files_and_contents",
    description: "A list of files to update along with their corresponding updated contents",
    item_name: "file_update",
    attributes: [
      { name: "explanation", description: "Brief explanation for how a change to a specified file makes progress towards the suggested update." },
      { name: "file_path", description: "The path of the file to update" },
      { name: "file_content", description: "The updated content for the file" }
    ]

  def initialize(suggestions:, doc_context:, code_context:, context_ignore_list:)
    @suggestions = suggestions
    @doc_context = doc_context
    @code_context = code_context
    @context_ignore_list = context_ignore_list
  end

  def generate
    super
  end

  def prompt
    <<~PROMPT
      You are tasked to make changes in the documentation repository based on suggestions.

      Use the following information to guide both tasks:

      1. Documentation update suggestions:
      #{@suggestions}

      2. Documentation repository structure:
      #{@doc_context}

      3. Code repository structure:
      #{@code_context}

      4. Files excluded from updates (do not modify these files):
      #{@context_ignore_list}

      5. Example of doc format:
      #{TEMPLATE_CONTENT}

      Your task:
      Generate the full updated content for each file that should be changed according to the suggestions.

      Guidelines:
      1. Do not make updates to any files excluded from updates
      2. Follow the format given in the example as a template for the structure of your file
      3. If a new page is added make sure to add them to the navigation as well
      3. If a link is added make sure it leads to an existing page, or create the new page being referenced
    PROMPT
  end
end
