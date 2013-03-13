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
    
    def change_property(prop, value)
      prop = prop.gsub("\n", "").split(" ")
      ([prop[0]].concat value.split(" ")).join(" ")
    end
    
    def save
      @file.close
      @file = File.open(@filename, "w")
      @lines.each do |line|
        @file.write(line[:content])
      end
      @file.close
      @file = File.open(@filename, "r")
    end
    
    def close
      @file.close
    end
    
    def method_missing(name, *args, &block)
      case name
        when /^.*=$/ then
          prop = @lines.select do |line| 
            (line[:type] == :property) and (property(line[:content])[:name].chomp.upcase == (name.to_s[0..-2]).chomp.upcase)
          end
          new_value = change_property(prop[0][:content], args[0])
          @lines.each_with_index do |line, i|
            if line[:content] == prop[0][:content]
              @lines[i][:content] = "#{new_value}\n"
            end
          end
          return new_value
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