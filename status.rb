require_relative 'user'
require_relative 'hashtag'

class Status
  attr_accessor :user, :message, :mentions, :hashtags

  def self.parse(json)
    params = {
      user: json['user']['screen_name'],
      message: json['text'],
      mentions: json['entities']['user_mentions'],
      hashtags: json['entities']['hashtags']
    }
    Status.new(params)
  end

  def initialize(params)
    @user, @message, @mentions, @hashtags = params[:user], params[:message], params[:mentions], params[:hashtags]
  end

  def to_s
    "message: #{@message}\n tweeter:#{@user}\n mentions: #{@mentions} ||\n hashtags: #{@hashtags.class}"
  end

  def mentions
    @mentions
  end

  def hashtags
    @hashtags.map! do |hash|
      Hashtag.parse(hash)
    end

    @hashtags
  end

end