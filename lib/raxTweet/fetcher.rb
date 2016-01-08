require "net/http"
require "simple_oauth"
require "uri"
require 'json'
require 'yaml'

module RaxTweet
  class Fetcher
    def initialize (file)
      @file = file
      @conf = nil
    end

    URL = 'https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name='

    def getConfig ()
      @conf = YAML::load_file(File.expand_path(@file, File.dirname(__FILE__)))
    end

    def constructHeaders ()
      params = {
        :consumer_key => @conf['oauth']['consumer_key'],
        :consumer_secret => @conf['oauth']['consumer_secret'],
        :token => @conf['oauth']['token'],
        :token_secret => @conf['oauth']['token_secret']
      }
      return SimpleOAuth::Header.new('get', URL + @conf['username'], {}, params)
    end

    def validate ()
      raise "missing config settings" unless @conf['username'] != '' && 
        @conf['oauth']['consumer_key'] != '' &&
        @conf['oauth']['consumer_secret'] != '' &&
        @conf['oauth']['token'] != '' &&
        @conf['oauth']['token_secret'] != ''
    end

    def fetch ()
        self.getConfig()
        self.validate()

        uri = URI.parse(URL + @conf['username'])

        request = Net::HTTP::Get.new(uri)
        request['Authorization'] = self.constructHeaders().to_s
        request['content-type'] = 'application/json'
        request['Accept-Encoding'] = ''
        request['Connection'] = 'Keep-Alive: timeout=15, max=100'

        response = Net::HTTP.start(
          uri.host, 
          uri.port, 
          :use_ssl => true, 
          :read_timeout => 10
        ) do |http|
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          http.request(request)
        end

        return JSON.parse(response.body)
    end
  end
end
