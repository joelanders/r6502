require 'spec_helper'

module R6502
  describe Memory do
    it "lets me set and get a value from a location" do
      memory = Memory.new
      memory.set(0x00, 0x0a)
      memory.get(0x00).should == 0x0a
    end
    it "truncates values above 0xff" do
      memory = Memory.new
      memory.set(0x10, 0xbbaa)
      memory.get(0x10).should == 0xaa
    end
    it "returns 0 for uninitialized memory" do
      memory = Memory.new
      memory.get(0x0b).should == 0x00
    end
    it "can retrieve two bytes" do
      memory = Memory.new
      memory.set(0xf0, 0x01)
      memory.set(0xf1, 0x02)
      memory.get_word(0xf0).should == 0x0201
    end
    it "can retrieve a range of bytes" do
      memory = Memory.new
      memory.set(0x00, 0x0a)
      memory.set(0x01, 0x0b)
      memory.set(0x02, 0x0c)
      memory.get_range(0x00, 0x02).should == [0x0a, 0x0b, 0x0c]
    end
  end
end
