module RaxTweet
  class Tweet
    def initialize(username, text, datetime)
      @username = username
      @text = text
      @datetime = datetime
    end

    def interpolate()
      return "#{@datetime} #{@username}: #{@text}"
    end
  end
end
