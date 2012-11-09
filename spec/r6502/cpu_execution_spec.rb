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
    it "Finds instruction and mode from opcode" do
      @cpu.instr_mode(0xa9).should == {:instr => :lda, :mode => :imm}
      @cpu.instr_mode(0x69).should == {:instr => :adc, :mode => :imm}
      @cpu.instr_mode(0x65).should == {:instr => :adc, :mode => :zp}
      @cpu.instr_mode(0x75).should == {:instr => :adc, :mode => :zpx}
      @cpu.instr_mode(0x0a).should == {:instr => :asl, :mode => :acc}
    end
    it "Finds the argument to the instruction" do
      # IMPLIED
      @cpu.decode_arg(:imp, 0x66, 0x66).should == nil
      # IMMEDIATE
      @cpu.decode_arg(:imm, 0x40, 0x66).should == 0x40
      # ZERO PAGE
      @cpu.decode_arg(:zp, 0x50, 0x66).should == 0x50
        # ZPX
      @cpu.x = 0xc0
      @cpu.decode_arg(:zpx, 0x0f, 0x66).should == 0xcf
        # ZPY
      @cpu.y = 0xb0
      @cpu.decode_arg(:zpy, 0x0f, 0x66).should == 0xbf
      # RELATIVE
      @cpu.pc = 0x100      #normally, pc inc'd during exectn and result
      @cpu.decode_arg(:rel, 0x80, 0x66).should == 0x180  #would be 0x182
      # ABSOLUTE
      @cpu.decode_arg(:abs, 0xff, 0x66).should == 0x66ff
        # ABSX
      @cpu.x = 0x10
      @cpu.decode_arg(:absx, 0xef, 0x66).should == 0x66ff
        # ABSY
      @cpu.y = 0x20
      @cpu.decode_arg(:absy, 0xdf, 0x66).should == 0x66ff
      # INDIRECT
      @cpu.mem.set(0x1000, 0x30)
      @cpu.mem.set(0x1001, 0x40)
      @cpu.decode_arg(:ind, 0x00, 0x10).should == 0x4030
        # INDX
      @cpu.x = 0x03
      @cpu.mem.set( 0xd0, 0xf0 )
      @cpu.mem.set( 0xd1, 0xd0 )
      @cpu.mem.set( 0xd0f0, 0x34 )
      @cpu.decode_arg(:indx, 0xcd, 0x66).should == 0x34
        # INDY
      @cpu.y = 0x04
      @cpu.mem.set( 0x10, 0xa0 )
      @cpu.mem.set( 0x11, 0xb0 )
      @cpu.mem.set( 0xb0a4, 0xcd )
      @cpu.decode_arg(:indy, 0x10, 0x66).should == 0xcd
    end
    it "executes a single instr. from PC value and mem" do
      @cpu.pc = 0x2000
      @mem.set(0x2000, 0xea) #nop
      @cpu.step
      @cpu.pc.should == 0x2001
    end
  end
end
