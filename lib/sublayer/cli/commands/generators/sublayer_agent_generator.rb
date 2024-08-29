class SublayerAgentGenerator < Sublayer::Generators::Base
  llm_output_adapter type: :named_strings,
    name: "sublayer_agent",
    description: "The new sublayer agent based on the description and supporting information",
    attributes: [
      { name: "code", description: "The code of the generated Sublayer agent" },
      { name: "filename", description: "The filename of the generated sublayer agent snake cased with a .rb extension" }
    ]

  def initialize(description:, trigger:, goal:, check_status:, step:)
    @description = description
    @trigger_condition = trigger
    @goal = goal
    @check_status = check_status
    @step = step
  end

  def generate
    super
  end

  def prompt
    <<-PROMPT
    You are an expert ruby programmer and great at repurposing code examples to use for new situations.

    A Sublayer agent is a DSL for defining a feedback loop for an AI agent. The agents sit running like a daemon and are triggered to run and step toward their goal checking status along the way.

    One example of a Sublayer agent is this one for doing TDD with RSpec:
    <example_tdd_agent>
    #{example_agent}
    </example_tdd_agent>

    Sublayer Agents take advantage of other Sublayer components to perform their tasks.
    Sublayer::Actions are used to perform actions in the outside world, things like saving files, making external api calls, retrieving data, etc
    Sublayer::Generators are used to make calls to LLMs based on information they receive from Sublayer::Actions or other sources and return structured data for other Sublayer::Actions to do use in the outside world

    The Sublayer Agent DSL consists of 4 main parts:
    1. trigger: What triggers the agent, currently built into the framework is the trigger_on_files_changed, but the trigger method also accepts a Sublayer::Triggers::Base subclass that defines an initialize method and a setup method that takes an agent as an argument
                The setup method then calls activate(agent) when the trigger condition is met
    2. goal: What the agent is trying to achieve, this is a block that returns a boolean
    3. check_status: A method that checks the status of the agent on its way toward the goal. Usually you update the goal condition here or can perform any Sublayer::Actions to examine the state of the outside world
    4. step: A method that encapsulates the way the agent should work toward the goal. Sublayer::Actions and Sublayer::Generators are used heavily here.

    Your goal is to rely on the above information about how Sublayer Agents work to generate a new Sublayer agent based on the following information:

    Agent description: #{@description}
    Trigger condition: #{@trigger}
    Goal condition: #{@goal}
    Status check method: #{@check_status}
    Step action method: #{@step}

    You can assume that any Sublayer::Actions or Sublayer::Generators you need are available to you in the Sublayer framework

    Take a deep breath and think step by step before coding. You can do this!
    PROMPT
  end

  def example_agent
    File.read(File.join(__dir__, "example_agent.rb"))
  end
end
