module Gritano
  class SshdConfig
    attr_reader :lines
    
    def initialize(filename)
      @filename = filename
      @file = File.open(@filename, "r")
    end
    
    def load
      @lines = []
      @file.readlines.each do |line|
        @lines << {content: line, type: type(line)}
      end
    end
    
    def type(line)
      case line[0] 
        when '#' then :comment
        when "\n" then :empty
        else :property
      end
    end
    
    def self.read(filename)
      sshd_config = SshdConfig.new(filename)
      sshd_config.load
      return sshd_config
    end
    
    def property(prop)
      content = prop.gsub("\n", "").split(" ")
      return {name: content[0], value: content[1..-1].join(' ')}
    end
    
    def method_missing(name, *args, &block)
      @lines.select{ |line| line[:type] == :property }.each do |p|
        prop = property(p[:content])
        return prop[:value] if prop[:name].chomp.upcase == name.to_s.chomp.upcase
      end
      raise NoMethodError
    end
  end
end