module JSON
  class << self
    alias_method :original_parse, :parse

    def parse(json, options = {})
      begin
        original_parse(json, options).with_indifferent_access
      rescue JSON::ParserError
        json = JSONFixingAgent.new(invalid_json: json).execute
        retry
      end
    end
  end
end
