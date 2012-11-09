require 'spec_helper'

module R6502
  describe "Cpu Execution" do
    before(:each) do
      @mem = Memory.new
      @mem.set(0xfffc, 0x00)
      @mem.set(0xfffd, 0x20)
      @cpu = Cpu.new(@mem)
    end
    it "has PC, S, X, Y, A registers" do
      @cpu.pc.should == 0x2000
      @cpu.s.should  == 0xff
      @cpu.x.should  == 0x00
      @cpu.y.should  == 0x00
      @cpu.a.should  == 0x00
    end
  end
end
