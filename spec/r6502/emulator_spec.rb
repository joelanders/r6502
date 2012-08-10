require 'spec_helper'

module R6502
  describe Emulator do
    it "Has registers" do
      @emu = Emulator.new
      @emu.pc = 0xfffe
      @emu.pc.should == 0xfffe
      @emu.s = 0xff
      @emu.s.should == 0xff
      @emu.p = 0xaa
      @emu.p.should == 0xaa
      @emu.a = 0xbb
      @emu.a.should == 0xbb
      @emu.x = 0xcc
      @emu.x.should == 0xcc
      @emu.y = 0xdd
      @emu.y.should == 0xdd
    end
    it "Has memory" do
      @emu = Emulator.new
      @emu.mem.set(0xfffe, 0x00)
      @emu.mem.set(0xffff, 0x01)
      @emu.mem.get(0xfffe).should == 0x00
      @emu.mem.get(0xffff).should == 0x01
    end
    it "Finds instruction and mode from opcode" do
      @emu = Emulator.new
      @emu.instr_mode(0xa9).should == {:instr => :lda, :mode => :imm}
      @emu.instr_mode(0x69).should == {:instr => :adc, :mode => :imm}
      @emu.instr_mode(0x65).should == {:instr => :adc, :mode => :zp}
      @emu.instr_mode(0x75).should == {:instr => :adc, :mode => :zpx}
    end
  end
end
