module Gritano
  class SshdConfig
    def initialize(filename)
      @filename = filename
      @file = File.open(@filename, "r")
    end
  end
end