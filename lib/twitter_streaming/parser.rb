require "twitter_streaming/stop_words"

module TwitterStreaming
  class Parser
    attr_reader :tweets

    def initialize(tweets: [])
      @tweets = tweets
    end

    def most_frequent
      filtered_words
        .uniq
        .map { |word| [word, filtered_words.count(word)] }
        .sort { |x,y| y[1] <=> x[1] }
        .take(10)
    end

    def filtered_words
      @_filtered_words ||= words.delete_if { |word| word.empty? || stop_words.include?(word) }
    end

    def stop_words
      @_stop_words ||= ::TwitterStreaming::StopWords.list
    end

    def words
      @_words ||= tweets.join(" ").split(" ").map do |word|
        word.strip.downcase.gsub(/[^a-z0-9\s]/i, '')
      end
    end
  end
end