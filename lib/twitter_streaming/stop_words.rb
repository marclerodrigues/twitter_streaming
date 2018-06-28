module TwitterStreaming
  class StopWords
    SUPPORT_FILE_PATH = "lib/support/stop_words.text"

    def self.list
      new.list
    end

    def list
      @_list ||= lines.map(&:strip).map(&:downcase)
    end

    private

    def lines
      @_file ||= IO.readlines(SUPPORT_FILE_PATH)
    end
  end
end