class RouteSelectionFromUserIntentGenerator < Sublayer::Generators::Base
  llm_output_adapter type: :string_selection_from_list,
    name: "route",
    description: "A route selected from the list",
    options: :available_routes

  def initialize(user_intent:)
    @user_intent = user_intent
  end

  def generate
    super
  end

  def available_routes
    ["GET /", "GET /users", "GET /users/:id", "POST /users", "PUT /users/:id", "DELETE /users/:id"]
  end

  def prompt
    <<-PROMPT
        You are skilled at selecting routes based on user intent.

        Your task is to choose a route based on the following intent:

        The user's intent is:
        #{@user_intent}
    PROMPT
  end
end
