module Gritano
  class SshdConfig
    def initialize(filename)
      @filename = filename
      @file = File.open(@filename, "r")
    end
    
    def load
      @file.readlines
    end
    
    def self.read(filename)
      sshd_config = SshdConfig.new(filename)
      sshd_config.load
    end
  end
end