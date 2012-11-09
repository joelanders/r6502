require 'spec_helper'

module R6502
  describe "Cpu Instructions" do
    before(:each) do
      @mem = Memory.new
      @cpu = Cpu.new(@mem)
    end
    # TODO
    it "sets cpu flags" do
      pending("not yet done")
    end
    # TODO
    it "obeys the decimal flag" do
      pending("not yet done")
    end
    # DEPENDS ON DECIMAL FLAG
    # TODO
    it "adc" do
      @cpu.a = 0x02
      @cpu.adc( {arg: 0x01, mode: :imm} )
      @cpu.a.should == 0x03
    end
    it "and" do
      @cpu.a = 0xab
      @cpu.and( {arg: 0x0f, mode: :imm} )
      @cpu.a.should == 0x0b
    end
    it "asl" do
      @cpu.a = 0x01
      @cpu.asl( {arg: nil, mode: :acc} )
      @cpu.a.should == 0x02
      @cpu.asl( {arg: nil, mode: :acc} )
      @cpu.a.should == 0x04

      @mem.set(0x2010, 0x04)
      @cpu.asl( {arg: 0x2010, mode: :abs} )
      @mem.get(0x2010).should == 0x08
      @cpu.asl( {arg: 0x2010, mode: :abs} )
      @mem.get(0x2010).should == 0x10
    end
    pending "bit" do
      #@cpu.bit(0x01, 0x02).should == 0x00
      @mem.set(0x3010, 0x01)
      @cpu.a = 0x02
      @cpu.z = 0
      @cpu.bit( {arg: 0x3010, mode: :abs} )
      @cpu.z.should == 1
    end
    it "dec" do
      @mem.set(0x4010, 0x02)
      @cpu.dec( {arg: 0x4010, mode: :abs} )
      @mem.get(0x4010).should == 0x01
      @cpu.dec( {arg: 0x4010, mode: :abs} )
      @mem.get(0x4010).should == 0x00
    end
    it "dex" do
      @cpu.x = 0x10
      @cpu.dex( {arg: nil, mode: :imp} )
      @cpu.x.should == 0x0f
    end
    it "dey" do
      @cpu.y = 0x0f
      @cpu.dey( {arg: nil, mode: :imp} )
      @cpu.y.should == 0x0e
    end
    it "eor" do
      @mem.set(0x1000, 0x05)
      @cpu.a = 0x06
      @cpu.eor( {arg: 0x1000, mode: :abs} )
      @cpu.a.should == 0x03

      @cpu.a = 0x06
      @cpu.eor( {arg: 0x05, mode: :imm} )
      @cpu.a.should == 0x03
    end
    it "inc" do
      @mem.set(0x2000, 0x0f)
      @cpu.inc( {arg: 0x2000, mode: :abs} )
      @mem.get(0x2000).should == 0x10
      @cpu.inc( {arg: 0x2000, mode: :abs} )
      @mem.get(0x2000).should == 0x11
    end
    it "inx" do
      @cpu.x = 0x00
      @cpu.inx( {arg: nil, mode: :imp} )
      @cpu.x.should == 0x01
      @cpu.inx( {arg: nil, mode: :imp} )
      @cpu.x.should == 0x02
    end
    it "iny" do
      @cpu.y = 0x03
      @cpu.iny( {arg: nil, mode: :imp} )
      @cpu.y.should == 0x04
      @cpu.iny( {arg: nil, mode: :imp} )
      @cpu.y.should == 0x05
    end
    it "lsr" do
      @cpu.a = 0x05
      @cpu.lsr( {arg: nil, mode: :acc} )
      @cpu.a.should == 0x02
      @cpu.lsr( {arg: nil, mode: :acc} )
      @cpu.a.should == 0x01

      @mem.set(0x1010, 0x07)
      @cpu.lsr( {arg: 0x1010, mode: :abs} )
      @mem.get(0x1010).should == 0x03
    end
    it "ora" do
      @cpu.a = 0x05
      @mem.set(0x1000, 0x06)
      @cpu.ora( {arg: 0x1000, mode: :abs} )
      @cpu.a.should == 0x07
      
      @cpu.a = 0x05
      @cpu.ora( {arg: 0x06, mode: :imm} )
      @cpu.a.should == 0x07
    end
    it "rol" do
      @cpu.a = 0x80
      @cpu.rol( {arg: nil, mode: :acc} )
      @cpu.a.should == 0x01
      @cpu.rol( {arg: nil, mode: :acc} )
      @cpu.a.should == 0x02

      @mem.set(0x900, 0x80)
      @cpu.rol( {arg: 0x900, mode: :abs} )
      @mem.get(0x900).should == 0x01
      @cpu.rol( {arg: 0x900, mode: :abs} )
      @mem.get(0x900).should == 0x02
    end
    it "ror" do
      @cpu.a = 0x01
      @cpu.ror( {arg: nil, mode: :acc} )
      @cpu.a.should == 0x80
      @cpu.ror( {arg: nil, mode: :acc} )
      @cpu.a.should == 0x40

      @mem.set(0x900, 0x01)
      @cpu.ror( {arg: 0x900, mode: :abs} )
      @mem.get(0x900).should == 0x80
      @cpu.ror( {arg: 0x900, mode: :abs} )
      @mem.get(0x900).should == 0x40
    end
    it "inx" do
      @cpu.x = 0x01
      @cpu.inx( {arg: nil, mode: :imp} )
      @cpu.x.should == 0x02
    end
    it "iny" do
      @cpu.y = 0x02
      @cpu.iny( {arg: nil, mode: :imp} )
      @cpu.y.should == 0x03
    end
    # DEPENDS ON DECIMAL FLAG
    # TODO
    it "sbc" do
      @cpu.a = 0x10
      @mem.set(0x100, 0x0a)
      @cpu.sbc( {arg: 0x100, mode: :abs} )
      @cpu.a.should == 0x06

      @cpu.a = 0x10
      @cpu.sbc( {arg: 0x0a, mode: :imm} )
      @cpu.a.should == 0x06
    end
    it "nop" do
      @cpu.nop({arg: nil, mode: :imp})
    end
    it "sec" do
      @cpu.c = 0
      @cpu.sec({})
      @cpu.c.should == 1
    end
    it "bcc" do
      @cpu.pc = 0x1000
      @cpu.c  = 1
      @cpu.bcc( {arg: 0x10, mode: :rel} )
      @cpu.pc.should == 0x1002

      @cpu.pc = 0x1000
      @cpu.c  = 0
      @cpu.bcc( {arg: 0x10, mode: :rel} )
      @cpu.pc.should == 0x1012
    end
  end
end
