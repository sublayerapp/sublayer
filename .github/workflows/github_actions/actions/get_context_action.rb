class GetContextAction < Sublayer::Actions::Base
  def initialize(path:)
    @path = path
  end

  def call
    ignored_patterns = load_contextignore
    files = get_files(ignored_patterns)
    concatenate_files(files)
  end

  private

  def load_contextignore
    contextignore_path = File.join(@path, '.contextignore')
    return [] unless File.exist?(contextignore_path)

    File.readlines(contextignore_path).map(&:strip).reject do |line|
      line.empty? || line.start_with?('#')
    end
  end

  def get_files(ignored_patterns)
    Dir.chdir(@path) do
      all_files = `git ls-files`.split("\n")
      all_files.reject do |file|
        ignored_patterns.any? do |pattern|
          File.fnmatch?(pattern, file) ||
            file.start_with?(pattern.chomp('/'))
        end
      end
    end
  end

  def concatenate_files(files)
    files.map do |file|
      content = File.read(File.join(@path, file))
      "File: #{file}\n#{content}\n\n"
    end.join
  end
end