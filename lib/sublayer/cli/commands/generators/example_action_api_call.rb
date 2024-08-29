class TextToSpeechAction < Sublayer::Actions::Base
  def initialize(text)
    @text = text
  end

  def call
    speech = HTTParty.post(
      "https://api.openai.com/v1/audio/speech",
      headers: {
        "Authorization" => "Bearer #{ENV["OPENAI_API_KEY"]}",
        "Content-Type" => "application/json",
      },
      body: {
        "model": "tts-1",
        "input": @text,
        "voice": "nova",
        "response_format": "wav"
      }.to_json
    )

    speech
  end
end
