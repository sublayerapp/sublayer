class FourDigitPasscodeGenerator < Sublayer::Generators::Base
  llm_output_adapter type: :single_integer,
    name: "four_digit_passcode",
    description: "an uncommon and difficult to guess four digit passcode"

  def initialize
  end

  def generate
    super
  end

  def prompt
    <<-PROMPT
    You are an expert of common four digit passcodes

    Provide a four digit passcode that is uncommon and hard to guess
    PROMPT
  end
end
