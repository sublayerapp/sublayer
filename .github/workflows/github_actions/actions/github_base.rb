# Description: Base class for Github-related Sublayer::Actions that abstracts away handling of the Octokit client and access token
class GithubBase < Sublayer::Actions::Base
  def initialize(repo:)
    @repo = repo
    @client = Octokit::Client.new(access_token: ENV["ACCESS_TOKEN"])
  end
end