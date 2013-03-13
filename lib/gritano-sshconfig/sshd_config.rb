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
      case name
        when /^.*=$/ then
          return 0
        else
          prop = @lines.select do |line| 
            (line[:type] == :property) and (property(line[:content])[:name].chomp.upcase == name.to_s.chomp.upcase)
          end
          return property(prop[0][:content])[:value] if prop.length == 1
      end
      raise NoMethodError
    end
  end
end