require_relative 'status'
require_relative 'user'
require 'rest-client'


class Hashtag
  attr_accessor :text

  def self.parse(params)
    Hashtag.new(params)
  end

  def initialize(params)
    @text = params["text"]
  end

  def text
    @text
  end

  def statuses
    hashtags = Addressable::URI.new(
    scheme: "https",
    host: "search.twitter.com",
    path: "search.json",
    query_values: {
      q: "##{@text}"
    }
    ).to_s

    tag_result = []
    JSON.parse(RestClient.get(hashtags).body)["results"].each do |tweet|
      params = {
        user: tweet['from_user_name'],
        message: tweet['text'],
        mentions: nil,
        hashtags: nil
      }
      tag_result << Status.new(params)
    end

    tag_result
  end

end