require 'launchy'
require 'oauth'
require 'yaml'

class TwitterSession

  CONSUMER_KEY = 'awiSzLtao0gE3H9fFWJag'
  CONSUMER_SECRET = 'sXAkoevaJtaWM9DmduFrzsLO7MS3PhxPKisEKHEfs'

  CONSUMER = OAuth::Consumer.new(CONSUMER_KEY, CONSUMER_SECRET, :site => 'https://twitter.com')

  def self.access_token
    request_token = CONSUMER.get_request_token
    authorize_url = request_token.authorize_url
    puts 'Go to this URL: #{authorize_url}'

    Launchy.open(authorize_url)

    puts 'Login, and type your verification code in'
    oauth_verifier = gets.chomp

    @@access_token = request_token.get_access_token(:oauth_verifier => oauth_verifier)
  end

  def self.get_token(token_file)
    if File.exist?(token_file)
      File.open(token_file) { |f| @@access_token = YAML.load(f)}
      @@access_token
    else
      @@access_token = TwitterSession.access_token
      p @@access_token
      File.open(token_file, 'w') { |f| YAML.dump(@@access_token, f)}

      @@access_token
    end
  end

end

