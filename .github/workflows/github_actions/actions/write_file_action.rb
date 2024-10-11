class WriteFileAction < Sublayer::Actions::Base
  def initialize(file_contents:, file_path:)
    @file_contents = file_contents
    @file_path = file_path
  end

  def call
    File.open(@file_path, 'wb') do |file|
      file.write(@file_contents)
    end
  end
end