require "twitter_streaming/parser"

module TwitterStreaming
  class Stream
    attr_accessor :tweets

    FIVE_MINUTES_IN_SECONDS = 300

    def initialize(tweets: [])
      @tweets = tweets
    end

    def word_count
      @_word_count ||= tweets.join(" ").split(" ").count
    end

    def most_frequent_words
      @_most_frequent_words ||= ::TwitterStreaming::Parser.new(tweets: tweets).most_frequent
    end

    def get_sample
      Thread.new do
        client.sample({ language: 'en' }) do |object|
          tweets << object.text if object.is_a?(::Twitter::Tweet)
        end
      end

      Thread.new do
        sleep FIVE_MINUTES_IN_SECONDS
        client.close
        puts "Finished getting tweets!\n"
      end
    end

    private

    def client
      @_client ||= Twitter::Streaming::Client.new do |config|
        config.consumer_key        = ENV["TWITTER_CONSUMER_KEY"]
        config.consumer_secret     = ENV["TWITTER_CONSUMER_SECRET"]
        config.access_token        = ENV["TWITTER_ACCESS_TOKEN"]
        config.access_token_secret = ENV["TWITTER_ACCESS_SECRET"]
      end
    end
  end
end
