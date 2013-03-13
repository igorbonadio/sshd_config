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
    
    def set_value(name, value)
      prop = @lines.select do |line| 
        (line[:type] == :property) and (property(line[:content])[:name].chomp.upcase == (name).chomp.upcase)
      end
      if prop.length == 1
        new_value = change_property(prop[0][:content], value)
        @lines.each_with_index do |line, i|
          if line[:content] == prop[0][:content]
            @lines[i][:content] = "#{new_value}\n"
          end
        end
        return new_value
      else
        new_value = "#{name} #{value}\n"
        @lines << {content: new_value, type: :property}
        return new_value
      end
    end
    
    def get_value(name)
      prop = @lines.select do |line| 
        (line[:type] == :property) and (property(line[:content])[:name].chomp.upcase == name.chomp.upcase)
      end
      if prop.length == 1
        return property(prop[0][:content])[:value]
      else
        raise NoMethodError
      end
    end
    
    def method_missing(name, *args, &block)
      return case name
        when /^.*=$/ then
          set_value(name.to_s[0..-2], args[0])
        else
          get_value(name.to_s)
      end
    end
  end
end
