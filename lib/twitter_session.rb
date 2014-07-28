require 'launchy'
require 'oauth'

class TwitterSession
  CONSUMER_KEY = File.read(Rails.root.join('.api_key')).chomp
  CONSUMER_SECRET = File.read(Rails.root.join('.api_secret')).chomp
  CONSUMER = OAuth::Consumer.new(
    CONSUMER_KEY, CONSUMER_SECRET, :site => "https://twitter.com")

  def self.get(path, query_values)
    JSON.parse(self.access_token.get(self.path_to_url(path, query_values)).body)
  end

  def self.post(path, req_params)
    JSON.parse(self.access_token.post(self.path_to_url(path, req_params)).body)
  end


  def self.access_token
    @access_token ||= self.request_access_token
  end

  def self.request_access_token
    request_token = CONSUMER.get_request_token
    authorize_url = request_token.authorize_url

    puts "Go to this URL: #{authorize_url}"
    Launchy.open(authorize_url)

    puts "Login, and type your verification code in"
    oauth_verifier = gets.chomp
    @access_token = request_token.get_access_token(
      :oauth_verifier => oauth_verifier
    )
  end

  def self.path_to_url(path, query_values={})
    Addressable::URI.new(
    :scheme => "https",
    :host => "api.twitter.com",
    :path => "1.1/#{path}.json",
    :query_values => query_values
    ).to_s
  end

end
