class PrimeNumberGenerator < Sublayer::Generators::Base
  llm_output_adapter type: :integer,
    name: "prime_number",
    description: "a prime number integer"

  def generate
    super
  end

  def prompt
    <<-PROMPT
      You are a great mathmatician.

      You are tasked with finding a prime number.

      Provide that prime number.
    PROMPT
  end
end
