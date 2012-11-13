require 'spec_helper'

module R6502
  describe "Cpu Instructions set flags" do
    before(:each) do
      @mem = Memory.new
      @cpu = Cpu.new(@mem)
    end
    describe "ADC sets flags" do
      it "adc 0" do
        @cpu.v = 0x1
        @cpu.z = 0x1
        @cpu.c = 0x1
        @cpu.n = 0x1

        @cpu.a = 0x01
        @cpu.adc(0x02, :imm)
        @cpu.a.should == 0x04
        @cpu.v.should == 0x0 #overflow
        @cpu.z.should == 0x0 #zero
        @cpu.c.should == 0x0 #carry
        @cpu.n.should == 0x0 #negative
      end
      it "adc 1" do
        @cpu.v = 0x1
        @cpu.z = 0x1
        @cpu.c = 0x0
        @cpu.n = 0x1

        @cpu.a = 0x0a
        @cpu.adc(0xff, :imm)
        @cpu.a.should == 0x09
        @cpu.v.should == 0x0 #overflow
        @cpu.z.should == 0x0 #zero
        @cpu.c.should == 0x1 #carry
        @cpu.n.should == 0x0 #negative
      end
      it "adc 2" do
        @cpu.v = 0x0
        @cpu.z = 0x1
        @cpu.c = 0x1
        @cpu.n = 0x0

        @cpu.a = 0x70
        @cpu.adc(0x70, :imm)
        @cpu.a.should == 0xe1
        @cpu.v.should == 0x1 #overflow
        @cpu.z.should == 0x0 #zero
        @cpu.c.should == 0x0 #carry
        @cpu.n.should == 0x1 #negative
      end
      it "adc 3" do
        @cpu.v = 0x0
        @cpu.z = 0x1
        @cpu.c = 0x0
        @cpu.n = 0x1

        @cpu.a = 0x80
        @cpu.adc(0x90, :imm)
        @cpu.a.should == 0x10
        @cpu.v.should == 0x1 #overflow
        @cpu.z.should == 0x0 #zero
        @cpu.c.should == 0x1 #carry
        @cpu.n.should == 0x0 #negative
      end
      it "adc 4" do
        @cpu.v = 0x1
        @cpu.z = 0x1
        @cpu.c = 0x0
        @cpu.n = 0x0

        @cpu.a = 0xf0
        @cpu.adc(0xf0, :imm)
        @cpu.a.should == 0xe0
        @cpu.v.should == 0x0 #overflow
        @cpu.z.should == 0x0 #zero
        @cpu.c.should == 0x1 #carry
        @cpu.n.should == 0x1 #negative
      end
      it "adc 5" do
        @cpu.v = 0x0
        @cpu.z = 0x1
        @cpu.c = 0x1
        @cpu.n = 0x1

        @cpu.a = 0x70
        @cpu.adc(0x80, :imm)
        @cpu.a.should == 0xf1
        @cpu.v.should == 0x0 #overflow
        @cpu.z.should == 0x0 #zero
        @cpu.c.should == 0x0 #carry
        @cpu.n.should == 0x1 #negative
      end
      it "adc 6" do
        @cpu.v = 0x0
        @cpu.z = 0x1
        @cpu.c = 0x1
        @cpu.n = 0x0

        @cpu.a = 0x70
        @cpu.adc(0x0f, :imm)
        @cpu.a.should == 0x80
        @cpu.v.should == 0x1 #overflow
        @cpu.z.should == 0x0 #zero
        @cpu.c.should == 0x0 #carry
        @cpu.n.should == 0x1 #negative
      end
      it "adc 7" do
        @cpu.v = 0x0
        @cpu.z = 0x0
        @cpu.c = 0x0
        @cpu.n = 0x1

        @cpu.a = 0x80
        @cpu.adc(0x80, :imm)
        @cpu.a.should == 0x00
        @cpu.v.should == 0x1 #overflow
        @cpu.z.should == 0x1 #zero
        @cpu.c.should == 0x1 #carry
        @cpu.n.should == 0x0 #negative
      end
      it "adc 8" do
        @cpu.v = 0x0
        @cpu.z = 0x0
        @cpu.c = 0x1
        @cpu.n = 0x1

        @cpu.a = 0x7f
        @cpu.adc(0x80, :imm)
        @cpu.a.should == 0x00
        @cpu.v.should == 0x0 #overflow
        @cpu.z.should == 0x1 #zero
        @cpu.c.should == 0x1 #carry
        @cpu.n.should == 0x0 #negative
      end
    end
    
    describe "SBC sets flags" do
      it "sbc 0" do
        @cpu.z = 0
        @cpu.c = 1

        @cpu.a = 0x10
        @cpu.sbc(0x10, :imm)
        @cpu.a.should == 0x0
        @cpu.z.should == 0x1
        @cpu.c.should == 1
        @cpu.v.should == 0
        @cpu.n.should == 0
      end
      it "sbc 1" do
        @cpu.z = 1
        @cpu.c = 1

        @cpu.a = 0x00
        @cpu.sbc(0x01, :imm)
        @cpu.a.should == 0xff
        @cpu.z.should == 0
        @cpu.c.should == 0
        @cpu.v.should == 0
        @cpu.n.should == 1
      end
      it "sbc 2" do
        @cpu.z = 1
        @cpu.c = 1

        @cpu.a = 0x80
        @cpu.sbc(0x01, :imm)
        @cpu.a.should == 0x7f
        @cpu.z.should == 0
        @cpu.c.should == 1
        @cpu.v.should == 1
        @cpu.n.should == 0
      end
      it "sbc 3" do
        @cpu.z = 1
        @cpu.c = 1

        @cpu.a = 0x7f
        @cpu.sbc(0xff, :imm)
        @cpu.a.should == 0x80
        @cpu.z.should == 0
        @cpu.c.should == 0
        @cpu.v.should == 1
        @cpu.n.should == 1
      end
      it "sbc 4" do
        @cpu.z = 1
        @cpu.c = 1

        @cpu.a = 0x00
        @cpu.sbc(0x00, :imm)
        @cpu.a.should == 0x00
        @cpu.z.should == 1
        @cpu.c.should == 1
        @cpu.v.should == 0
        @cpu.n.should == 0
      end
      it "sbc 5" do
        @cpu.z = 1
        @cpu.c = 0

        @cpu.a = 0x00
        @cpu.sbc(0x00, :imm)
        @cpu.a.should == 0xff
        @cpu.z.should == 0
        @cpu.c.should == 0
        @cpu.v.should == 0
        @cpu.n.should == 1
      end
    end
  end
  describe "Cpu Instructions" do
    before(:each) do
      @mem = Memory.new
      @cpu = Cpu.new(@mem)
    end
    # TODO
    it "obeys the decimal flag" do
      pending("not yet done")
    end
    # DEPENDS ON DECIMAL FLAG
    # TODO
    it "adc" do
      @cpu.a = 0x02
      @cpu.adc(0x01, :imm)
      @cpu.a.should == 0x03

      @mem.set(0x1000, 0xf0)
      @cpu.adc(0x1000, :abs)
      @cpu.a.should == 0xf3
    end
    it "and" do
      @cpu.a = 0xab
      @cpu.and(0x0f, :imm)
      @cpu.a.should == 0x0b
    end
    it "asl" do
      @cpu.a = 0x01
      @cpu.asl(nil, :acc)
      @cpu.a.should == 0x02
      @cpu.asl(nil, :acc)
      @cpu.a.should == 0x04

      @mem.set(0x2010, 0x04)
      @cpu.asl(0x2010, :abs)
      @mem.get(0x2010).should == 0x08
      @cpu.asl(0x2010, :abs)
      @mem.get(0x2010).should == 0x10
    end
    it "bit" do
      @mem.set(0x3010, 0xf1)
      @cpu.a = 0x02
      @cpu.z = 0
      @cpu.v = 0
      @cpu.n = 0

      @cpu.bit(0x3010, :abs)
      @cpu.z.should == 1
      @cpu.a.should == 0x02
      @mem.get(0x3010).should == 0xf1
      @cpu.v.should == 1
      @cpu.n.should == 1
    end
    it "dec" do
      @mem.set(0x4010, 0x02)
      @cpu.dec(0x4010, :abs)
      @mem.get(0x4010).should == 0x01
      @cpu.dec(0x4010, :abs)
      @mem.get(0x4010).should == 0x00
    end
    it "dex" do
      @cpu.x = 0x10
      @cpu.dex(nil, :imp)
      @cpu.x.should == 0x0f
    end
    it "dey" do
      @cpu.y = 0x0f
      @cpu.dey(nil, :imp)
      @cpu.y.should == 0x0e
    end
    it "eor" do
      @mem.set(0x1000, 0x05)
      @cpu.a = 0x06
      @cpu.eor(0x1000, :abs)
      @cpu.a.should == 0x03

      @cpu.a = 0x06
      @cpu.eor(0x05, :imm)
      @cpu.a.should == 0x03
    end
    it "inc" do
      @mem.set(0x2000, 0x0f)
      @cpu.inc(0x2000, :abs)
      @mem.get(0x2000).should == 0x10
      @cpu.inc(0x2000, :abs)
      @mem.get(0x2000).should == 0x11
    end
    it "inx" do
      @cpu.x = 0x00
      @cpu.inx(nil, :imp)
      @cpu.x.should == 0x01
      @cpu.inx(nil, :imp)
      @cpu.x.should == 0x02
    end
    it "iny" do
      @cpu.y = 0x03
      @cpu.iny(nil, :imp)
      @cpu.y.should == 0x04
      @cpu.iny(nil, :imp)
      @cpu.y.should == 0x05
    end
    it "lsr" do
      @cpu.a = 0x05
      @cpu.lsr(nil, :acc)
      @cpu.a.should == 0x02
      @cpu.lsr(nil, :acc)
      @cpu.a.should == 0x01

      @mem.set(0x1010, 0x07)
      @cpu.lsr(0x1010, :abs)
      @mem.get(0x1010).should == 0x03
    end
    it "ora" do
      @cpu.a = 0x05
      @mem.set(0x1000, 0x06)
      @cpu.ora(0x1000, :abs)
      @cpu.a.should == 0x07
      
      @cpu.a = 0x05
      @cpu.ora(0x06, :imm)
      @cpu.a.should == 0x07
    end
    it "rol" do
      @cpu.a = 0x80
      @cpu.rol(nil, :acc)
      @cpu.a.should == 0x01
      @cpu.rol(nil, :acc)
      @cpu.a.should == 0x02

      @mem.set(0x900, 0x80)
      @cpu.rol(0x900, :abs)
      @mem.get(0x900).should == 0x01
      @cpu.rol(0x900, :abs)
      @mem.get(0x900).should == 0x02
    end
    it "ror" do
      @cpu.a = 0x01
      @cpu.ror(nil, :acc)
      @cpu.a.should == 0x80
      @cpu.ror(nil, :acc)
      @cpu.a.should == 0x40

      @mem.set(0x900, 0x01)
      @cpu.ror(0x900, :abs)
      @mem.get(0x900).should == 0x80
      @cpu.ror(0x900, :abs)
      @mem.get(0x900).should == 0x40
    end
    it "inx" do
      @cpu.x = 0x01
      @cpu.inx(nil, :imp)
      @cpu.x.should == 0x02
    end
    it "iny" do
      @cpu.y = 0x02
      @cpu.iny(nil, :imp)
      @cpu.y.should == 0x03
    end
    # DEPENDS ON DECIMAL FLAG
    # TODO
    it "sbc" do
      @cpu.c = 1
      @cpu.a = 0x10
      @mem.set(0x100, 0x0a)
      @cpu.sbc(0x100, :abs)
      @cpu.a.should == 0x06

      @cpu.c = 0
      @cpu.a = 0x10
      @cpu.sbc(0x0a, :imm)
      @cpu.a.should == 0x05
    end
    it "nop" do
      @cpu.nop(nil, :imp)
    end
    it "sec" do
      @cpu.c = 0
      @cpu.sec(nil, :imp)
      @cpu.c.should == 1
    end
    it "sed" do
      @cpu.d = 0
      @cpu.sed(nil, :imp)
      @cpu.d.should == 1
    end
    it "sei" do
      @cpu.i = 0
      @cpu.sei(nil, :imp)
      @cpu.i.should == 1
    end
    it "bcc" do
      @cpu.pc = 0x1000
      @cpu.c  = 1
      @cpu.bcc(0x10, :rel)
      @cpu.pc.should == 0x1002

      @cpu.pc = 0x1000
      @cpu.c  = 0
      @cpu.bcc(0x10, :rel)
      @cpu.pc.should == 0x1012
    end
    it "bcs" do
      @cpu.pc = 0x1000
      @cpu.c  = 0
      @cpu.bcs(0x10, :rel)
      @cpu.pc.should == 0x1002

      @cpu.pc = 0x1000
      @cpu.c  = 1
      @cpu.bcs(0x10, :rel)
      @cpu.pc.should == 0x1012
    end
    it "beq" do
      @cpu.pc = 0x1000
      @cpu.z  = 0
      @cpu.beq(0x10, :rel)
      @cpu.pc.should == 0x1002

      @cpu.pc = 0x1000
      @cpu.z  = 1
      @cpu.beq(0x10, :rel)
      @cpu.pc.should == 0x1012
    end
    it "bmi" do
      @cpu.pc = 0x1000
      @cpu.n  = 0
      @cpu.bmi(0x10, :rel)
      @cpu.pc.should == 0x1002

      @cpu.pc = 0x1000
      @cpu.n  = 1
      @cpu.bmi(0x10, :rel)
      @cpu.pc.should == 0x1012
    end
    it "bne" do
      @cpu.pc = 0x1000
      @cpu.z  = 0
      @cpu.bne(0x10, :rel)
      @cpu.pc.should == 0x1002

      @cpu.pc = 0x1000
      @cpu.z  = 1
      @cpu.bne(0x10, :rel)
      @cpu.pc.should == 0x1012
    end
    it "bpl" do
      @cpu.pc = 0x1000
      @cpu.n  = 1
      @cpu.bpl(0x10, :rel)
      @cpu.pc.should == 0x1002

      @cpu.pc = 0x1000
      @cpu.n  = 0
      @cpu.bpl(0x10, :rel)
      @cpu.pc.should == 0x1012
    end
    it "bvc" do
      @cpu.pc = 0x1000
      @cpu.v  = 1
      @cpu.bvc(0x10, :rel)
      @cpu.pc.should == 0x1002

      @cpu.pc = 0x1000
      @cpu.v  = 0
      @cpu.bvc(0x10, :rel)
      @cpu.pc.should == 0x1012
    end
    it "bvs" do
      @cpu.pc = 0x1000
      @cpu.v  = 0
      @cpu.bvs(0x10, :rel)
      @cpu.pc.should == 0x1002

      @cpu.pc = 0x1000
      @cpu.v  = 1
      @cpu.bvs(0x10, :rel)
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
      @cpu.v = 1
      @cpu.clv
      @cpu.v.should == 0

      @cpu.v = 0
      @cpu.clv
      @cpu.v.should == 0
    end
    #TODO negative flag
    it "cmp" do
      @mem.set(0x1000, 0x10)
      @cpu.a = 0x20
      @cpu.c = 0
      @cpu.z = 1
      @cpu.cmp(0x1000, :abs)
      @cpu.a.should == 0x20
      @cpu.c.should == 1
      @cpu.z.should == 0

      @cpu.a = 0x10
      @cpu.c = 0
      @cpu.z = 0
      @cpu.cmp(0x10, :imm)
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
      @cpu.cpx(0x1000, :abs)
      @cpu.x.should == 0x20
      @cpu.c.should == 1
      @cpu.z.should == 0

      @cpu.x = 0x10
      @cpu.c = 0
      @cpu.z = 0
      @cpu.cpx(0x10, :imm)
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
      @cpu.cpy(0x1000, :abs)
      @cpu.y.should == 0x20
      @cpu.c.should == 1
      @cpu.z.should == 0

      @cpu.y = 0x10
      @cpu.c = 0
      @cpu.z = 0
      @cpu.cpy(0x10, :imm)
      @cpu.y.should == 0x10
      @cpu.c.should == 1
      @cpu.z.should == 1
    end
    it "jmp" do
      @cpu.pc = 0x1000
      @cpu.jmp(0x2000, :abs)
      @cpu.pc.should == 0x2000

      @cpu.pc = 0x1000
      @mem.set( 0x2000, 0x00 )
      @mem.set( 0x2001, 0x11 )
      @cpu.jmp(0x2000, :ind)
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
      @cpu.lda(0x33, :imm)
      @cpu.a.should == 0x33

      @cpu.a = 0x66
      @mem.set( 0x1000, 0x44 )
      @cpu.lda(0x1000, :abs)
      @cpu.a.should == 0x44
    end
    it "ldx" do
      @cpu.x = 0x66
      @cpu.ldx(0x33, :imm)
      @cpu.x.should == 0x33

      @cpu.x = 0x66
      @mem.set( 0x1000, 0x44 )
      @cpu.ldx(0x1000, :abs)
      @cpu.x.should == 0x44
    end
    it "ldy" do
      @cpu.y = 0x66
      @cpu.ldy(0x33, :imm)
      @cpu.y.should == 0x33

      @cpu.y = 0x66
      @mem.set( 0x1000, 0x44 )
      @cpu.ldy(0x1000, :abs)
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
      @cpu.v = 0
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
      @cpu.v = 1
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
      @cpu.v = 0
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
      @cpu.v.should == 1
      @cpu.n.should == 0
    end
    pending "rti"
    it "sta" do
      @cpu.a = 0xfa
      @mem.set( 0x1000, 0xaf )
      @cpu.sta(0x1000, :abs)
      @mem.get( 0x1000 ).should == 0xfa
    end
    it "stx" do
      @cpu.x = 0xfa
      @mem.set( 0x1000, 0xaf )
      @cpu.stx(0x1000, :abs)
      @mem.get( 0x1000 ).should == 0xfa
    end
    it "sty" do
      @cpu.y = 0xfa
      @mem.set( 0x1000, 0xaf )
      @cpu.sty(0x1000, :abs)
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
