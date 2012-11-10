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
    it "bit" do
      @mem.set(0x3010, 0xf1)
      @cpu.a = 0x02
      @cpu.z = 0
      @cpu.o = 0
      @cpu.n = 0

      @cpu.bit( {arg: 0x3010, mode: :abs} )
      @cpu.z.should == 1
      @cpu.a.should == 0x02
      @mem.get(0x3010).should == 0xf1
      @cpu.o.should == 1
      @cpu.n.should == 1
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
    it "sed" do
      @cpu.d = 0
      @cpu.sed({})
      @cpu.d.should == 1
    end
    it "sei" do
      @cpu.i = 0
      @cpu.sei({})
      @cpu.i.should == 1
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
    it "bcs" do
      @cpu.pc = 0x1000
      @cpu.c  = 0
      @cpu.bcs( {arg: 0x10, mode: :rel} )
      @cpu.pc.should == 0x1002

      @cpu.pc = 0x1000
      @cpu.c  = 1
      @cpu.bcs( {arg: 0x10, mode: :rel} )
      @cpu.pc.should == 0x1012
    end
    it "beq" do
      @cpu.pc = 0x1000
      @cpu.z  = 0
      @cpu.beq( {arg: 0x10, mode: :rel} )
      @cpu.pc.should == 0x1002

      @cpu.pc = 0x1000
      @cpu.z  = 1
      @cpu.beq( {arg: 0x10, mode: :rel} )
      @cpu.pc.should == 0x1012
    end
    it "bmi" do
      @cpu.pc = 0x1000
      @cpu.n  = 0
      @cpu.bmi( {arg: 0x10, mode: :rel} )
      @cpu.pc.should == 0x1002

      @cpu.pc = 0x1000
      @cpu.n  = 1
      @cpu.bmi( {arg: 0x10, mode: :rel} )
      @cpu.pc.should == 0x1012
    end
    it "bne" do
      @cpu.pc = 0x1000
      @cpu.z  = 0
      @cpu.bne( {arg: 0x10, mode: :rel} )
      @cpu.pc.should == 0x1002

      @cpu.pc = 0x1000
      @cpu.z  = 1
      @cpu.bne( {arg: 0x10, mode: :rel} )
      @cpu.pc.should == 0x1012
    end
    it "bpl" do
      @cpu.pc = 0x1000
      @cpu.n  = 1
      @cpu.bpl( {arg: 0x10, mode: :rel} )
      @cpu.pc.should == 0x1002

      @cpu.pc = 0x1000
      @cpu.n  = 0
      @cpu.bpl( {arg: 0x10, mode: :rel} )
      @cpu.pc.should == 0x1012
    end
    it "bvc" do
      @cpu.pc = 0x1000
      @cpu.o  = 1
      @cpu.bvc( {arg: 0x10, mode: :rel} )
      @cpu.pc.should == 0x1002

      @cpu.pc = 0x1000
      @cpu.o  = 0
      @cpu.bvc( {arg: 0x10, mode: :rel} )
      @cpu.pc.should == 0x1012
    end
    it "bvs" do
      @cpu.pc = 0x1000
      @cpu.o  = 0
      @cpu.bvs( {arg: 0x10, mode: :rel} )
      @cpu.pc.should == 0x1002

      @cpu.pc = 0x1000
      @cpu.o  = 1
      @cpu.bvs( {arg: 0x10, mode: :rel} )
      @cpu.pc.should == 0x1012
    end
    pending "brk" do
    end
    it "clc" do
      @cpu.c = 1
      @cpu.clc
      @cpu.c.should == 0

      @cpu.c = 0
      @cpu.clc
      @cpu.c.should == 0
    end
    it "cld" do
      @cpu.d = 1
      @cpu.cld
      @cpu.d.should == 0

      @cpu.d = 0
      @cpu.cld
      @cpu.d.should == 0
    end
    it "cli" do
      @cpu.i = 1
      @cpu.cli
      @cpu.i.should == 0

      @cpu.i = 0
      @cpu.cli
      @cpu.i.should == 0
    end
    it "clv" do
      @cpu.o = 1
      @cpu.clv
      @cpu.o.should == 0

      @cpu.o = 0
      @cpu.clv
      @cpu.o.should == 0
    end
    #TODO negative flag
    it "cmp" do
      @mem.set(0x1000, 0x10)
      @cpu.a = 0x20
      @cpu.c = 0
      @cpu.z = 1
      @cpu.cmp( {arg: 0x1000, mode: :abs} )
      @cpu.a.should == 0x20
      @cpu.c.should == 1
      @cpu.z.should == 0

      @cpu.a = 0x10
      @cpu.c = 0
      @cpu.z = 0
      @cpu.cmp( {arg: 0x10, mode: :imm} )
      @cpu.a.should == 0x10
      @cpu.c.should == 1
      @cpu.z.should == 1
    end
    #TODO negative flag
    it "cpx" do
      @mem.set(0x1000, 0x10)
      @cpu.x = 0x20
      @cpu.c = 0
      @cpu.z = 1
      @cpu.cpx( {arg: 0x1000, mode: :abs} )
      @cpu.x.should == 0x20
      @cpu.c.should == 1
      @cpu.z.should == 0

      @cpu.x = 0x10
      @cpu.c = 0
      @cpu.z = 0
      @cpu.cpx( {arg: 0x10, mode: :imm} )
      @cpu.x.should == 0x10
      @cpu.c.should == 1
      @cpu.z.should == 1
    end
    #TODO negative flag
    it "cpy" do
      @mem.set(0x1000, 0x10)
      @cpu.y = 0x20
      @cpu.c = 0
      @cpu.z = 1
      @cpu.cpy( {arg: 0x1000, mode: :abs} )
      @cpu.y.should == 0x20
      @cpu.c.should == 1
      @cpu.z.should == 0

      @cpu.y = 0x10
      @cpu.c = 0
      @cpu.z = 0
      @cpu.cpy( {arg: 0x10, mode: :imm} )
      @cpu.y.should == 0x10
      @cpu.c.should == 1
      @cpu.z.should == 1
    end
    it "jmp" do
      @cpu.pc = 0x1000
      @cpu.jmp( {arg: 0x2000, mode: :abs} )
      @cpu.pc.should == 0x2000

      @cpu.pc = 0x1000
      @mem.set( 0x2000, 0x00 )
      @mem.set( 0x2001, 0x11 )
      @cpu.jmp( {arg: 0x2000, mode: :ind} )
      @cpu.pc.should == 0x1100
    end
    pending "jsr" do
      #need stack push instr first
    end
    pending "rts" do
      #need stack pull instr first
    end
    it "lda" do
      @cpu.a = 0x66
      @cpu.lda( {arg: 0x33, mode: :imm} )
      @cpu.a.should == 0x33

      @cpu.a = 0x66
      @mem.set( 0x1000, 0x44 )
      @cpu.lda( {arg:0x1000, mode: :abs} )
      @cpu.a.should == 0x44
    end
    it "ldx" do
      @cpu.x = 0x66
      @cpu.ldx( {arg: 0x33, mode: :imm} )
      @cpu.x.should == 0x33

      @cpu.x = 0x66
      @mem.set( 0x1000, 0x44 )
      @cpu.ldx( {arg:0x1000, mode: :abs} )
      @cpu.x.should == 0x44
    end
    it "ldy" do
      @cpu.y = 0x66
      @cpu.ldy( {arg: 0x33, mode: :imm} )
      @cpu.y.should == 0x33

      @cpu.y = 0x66
      @mem.set( 0x1000, 0x44 )
      @cpu.ldy( {arg:0x1000, mode: :abs} )
      @cpu.y.should == 0x44
    end
    it "pha" do
      @cpu.a = 0x33
      @cpu.s = 0xff
      @cpu.pha()
      @cpu.s.should == 0xfe
      @mem.get(0x01ff).should == 0x33
    end
    it "pla" do
      @cpu.a = 0x66
      @cpu.s = 0xfe
      @mem.set(0x01ff, 0x34)
      @cpu.pla()
      @cpu.a.should == 0x34
      @cpu.s.should == 0xff
    end
    it "php" do
      @cpu.c = 1
      @cpu.z = 0
      @cpu.i = 1
      @cpu.d = 0
      @cpu.b = 1
      #bit 5   1
      @cpu.o = 0
      @cpu.n = 1

      @cpu.s = 0xff
      @cpu.php()
      @cpu.s.should == 0xfe
      @mem.get( 0x01ff ).should == 0b10110101

      @cpu.c = 0
      @cpu.z = 1
      @cpu.i = 0
      @cpu.d = 1
      @cpu.b = 0
      #bit 5   1
      @cpu.o = 1
      @cpu.n = 0

      @cpu.s = 0xfe
      @cpu.php()
      @cpu.s.should == 0xfd
      @mem.get( 0x01fe ).should == 0b01101010
    end
    it "plp" do
      @cpu.c = 1
      @cpu.z = 0
      @cpu.i = 1
      @cpu.d = 0
      @cpu.b = 1
      #bit 5   1
      @cpu.o = 0
      @cpu.n = 1

      @mem.set(0x01ff, 0b01101010)
      @cpu.s = 0xfe
      @cpu.plp()

      @cpu.c.should == 0
      @cpu.z.should == 1
      @cpu.i.should == 0
      @cpu.d.should == 1
      @cpu.b.should == 0
      #bit 5           1
      @cpu.o.should == 1
      @cpu.n.should == 0
    end
    pending "rti"
    it "sta" do
      @cpu.a = 0xfa
      @mem.set( 0x1000, 0xaf )
      @cpu.sta( {arg: 0x1000, mode: :abs} )
      @mem.get( 0x1000 ).should == 0xfa
    end
    it "stx" do
      @cpu.x = 0xfa
      @mem.set( 0x1000, 0xaf )
      @cpu.stx( {arg: 0x1000, mode: :abs} )
      @mem.get( 0x1000 ).should == 0xfa
    end
    it "sty" do
      @cpu.y = 0xfa
      @mem.set( 0x1000, 0xaf )
      @cpu.sty( {arg: 0x1000, mode: :abs} )
      @mem.get( 0x1000 ).should == 0xfa
    end
    it "tax" do
      @cpu.x = 0xea
      @cpu.a = 0xbd
      @cpu.tax()
      @cpu.a.should == 0xbd
      @cpu.x.should == 0xbd
    end
    it "tay" do
      @cpu.y = 0xea
      @cpu.a = 0xbd
      @cpu.tay()
      @cpu.a.should == 0xbd
      @cpu.y.should == 0xbd
    end
    it "tsx" do
      @cpu.x = 0xea
      @cpu.s = 0xbd
      @cpu.tsx()
      @cpu.s.should == 0xbd
      @cpu.x.should == 0xbd
    end
    it "txa" do
      @cpu.a = 0xea
      @cpu.x = 0xbd
      @cpu.txa()
      @cpu.x.should == 0xbd
      @cpu.a.should == 0xbd
    end
    it "txs" do
      @cpu.s = 0xea
      @cpu.x = 0xbd
      @cpu.txs()
      @cpu.x.should == 0xbd
      @cpu.s.should == 0xbd
    end
    it "tya" do
      @cpu.a = 0xea
      @cpu.y = 0xbd
      @cpu.tya()
      @cpu.y.should == 0xbd
      @cpu.a.should == 0xbd
    end
  end
end
