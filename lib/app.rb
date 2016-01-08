require_relative 'raxTweet'
require 'optparse'

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"
  opts.on("-c", "--conf[=config]", "Directory to the config YAML file relative to app.rb") do |v|
    options[:config] = v
  end
end.parse!

path = options[:config] || '../../config/default.yml'

RaxTweet::Fetcher.new(path).fetch().each do |tweet|
  raxTweet = RaxTweet::Tweet.new(
    tweet['screen_name'], 
    tweet['text'], 
    tweet['created_at']
  )
  puts raxTweet.interpolate
end
