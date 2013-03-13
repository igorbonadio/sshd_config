require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module Gritano
  describe "SshdConfig" do
    it "should open a sshd_config file" do
      File.should_receive(:open).with(File.join(File.dirname(__FILE__), 'data', 'sshd_config'), "r")
      SshdConfig.new(File.join(File.dirname(__FILE__), 'data', 'sshd_config'))
    end
    
    it "should read a sshd_config file" do
      File.any_instance.should_receive(:readlines).and_return([])
      SshdConfig.read(File.join(File.dirname(__FILE__), 'data', 'sshd_config'))
    end
    
    it "should have an internal representation of the sshd_config file" do
      sshd_config = SshdConfig.read(File.join(File.dirname(__FILE__), 'data', 'sshd_config'))
      sshd_config.lines.length.should be == 132
      sshd_config.lines[0][:type].should be == :comment
      sshd_config.lines[1][:type].should be == :empty
      sshd_config.lines[12][:type].should be == :property
    end
    
    it "should get parameters from sshd_config file" do
      sshd_config = SshdConfig.read(File.join(File.dirname(__FILE__), 'data', 'sshd_config'))
      sshd_config.port.should be == "22"
    end
    
    it "should set parameters from sshd_config file" do
      sshd_config = SshdConfig.read(File.join(File.dirname(__FILE__), 'data', 'sshd_config'))
      sshd_config.port = "33"
      sshd_config.port.should be == "33"
    end
    
    it "should write a sshd_config file"
    it "should keep original comments"
    it "should write new comments"
  end
end