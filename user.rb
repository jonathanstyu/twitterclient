require_relative 'twittersession'
require_relative 'status'
require_relative 'hashtag'
require 'addressable/uri'
require 'json'

class User

  attr_reader :token

  def initialize(username)
    @username = username
    @token = TwitterSession.get_token(username)
  end

  def timeline
    timeline_request = Addressable::URI.new(
    scheme: "https",
    host: "api.twitter.com",
    path: "1.1/statuses/user_timeline.json",
    query_values: {
      screen_name: @username,
      count: 3
    }
    ).to_s

    timeline_json = JSON.parse(@token.get(timeline_request).body)

    timeline = []

    timeline_json.each do |tweet|
      timeline << Status.parse(tweet)
    end

    timeline
  end

  def followers
    followers = []

    followers_request = Addressable::URI.new(
    scheme: "https",
    host: "api.twitter.com",
    path: "1.1/followers/list.json",
    query_values: {
      screen_name: @username,
      count: 3
    }
    ).to_s

    JSON.parse(@token.get(followers_request).body)['users'].each do |user|
      followers << user['screen_name']
    end

    followers
  end

  def followed_users
    friends = []

    f_request = Addressable::URI.new(
    scheme: "https",
    host: "api.twitter.com",
    path: "1.1/friends/list.json",
    query_values: {
      screen_name: @username,
      count: 3
    }
    ).to_s

    JSON.parse(@token.get(f_request).body)['users'].each do |user|
      friends << user['screen_name']
    end

    friends
  end

end


class EndUser < User
  def self.set_user_name(user_name)
    @@current_user = EndUser.new(user_name)
  end

  def self.me
    @@current_user
  end

  def initialize(user_name)
    super(user_name)
  end

  def post_status(status_text)
    post_request = Addressable::URI.new(
    scheme: "https",
    host: "api.twitter.com",
    path: "1.1/statuses/update.json",
    query_values: {
      status: status_text
    }
    ).to_s

    @token.post(post_request).body

    puts "tweet posted"

  end

  def direct_message(other_user, text)
    post_request = Addressable::URI.new(
    scheme: "https",
    host: "api.twitter.com",
    path: "1.1/direct_messages/new.json",
    query_values: {
      screen_name: other_user,
      text: text
    }
    ).to_s

    @token.post(post_request).body

    puts "direct message posted"
  end

end