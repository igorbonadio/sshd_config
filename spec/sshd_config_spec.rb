require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module Gritano
  describe "SshdConfig" do
    it "should open a sshd_config file" do
      File.should_receive(:open).with(File.join(File.dirname(__FILE__), 'data', 'sshd_config'), "r")
      SshdConfig.new(File.join(File.dirname(__FILE__), 'data', 'sshd_config'))
    end
    
    it "should read a sshd_config file" do
      File.any_instance.should_receive(:readlines)
      sshd_config = SshdConfig.read(File.join(File.dirname(__FILE__), 'data', 'sshd_config'))
    end
    
    it "should get parameters from sshd_config file"
    it "should set parameters from sshd_config file"
    it "should write a sshd_config file"
    it "should keep original comments"
    it "should write new comments"
  end
end