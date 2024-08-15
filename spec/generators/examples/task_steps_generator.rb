class TaskStepsGenerator < Sublayer::Generators::Base
  llm_output_adapter type: :list_of_named_strings,
    name: "steps",
    description: "List of steps to complete a task",
    item_name: "step",
    attributes: [ { name: "description", description: "A brief description of the step" }, { name: "command", description: "The command to execute for this step" } ]

  def initialize(task:)
    @task = task
  end

  def generate
    super
  end

  def prompt
    <<-PROMPT
    You are an expert at breaking down tasks into step-by-step instructions with associated commands.
    Please generate a list of steps to complete the following task:

    #{@task}

    For each step, provide:
    - description: A brief description of what the step accomplishes
    - command: The exact command to execute for this step (if applicable; use "N/A" if no command is needed)

    Provide your response as a list of objects, each containing the above attributes.
    Ensure the steps are in the correct order to complete the task successfully.
    PROMPT
  end
end
