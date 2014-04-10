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

    describe "ADC and SBC BCD" do
      it "adc bcd" do
        @cpu.d = 1

        @cpu.a = 0x09
        @cpu.clc(nil, :imp)
        @cpu.adc(0x02, :imm)
        @cpu.a.should == 0x11
        @cpu.c.should == 0
        @cpu.z.should == 0
        @cpu.n.should == 0

        @cpu.a = 0x49
        @cpu.clc(nil, :imp)
        @cpu.adc(0x49, :imm)
        @cpu.a.should == 0x98
        @cpu.c.should == 0
        @cpu.z.should == 0
        @cpu.n.should == 1

        @cpu.a = 0x90
        @cpu.clc(nil, :imp)
        @cpu.adc(0x10, :imm)
        @cpu.a.should == 0x00
        @cpu.c.should == 1
        @cpu.z.should == 1
        @cpu.n.should == 0

        @cpu.a = 0x99
        @cpu.clc(nil, :imp)
        @cpu.adc(0x99, :imm)
        @cpu.a.should == 0x98
        @cpu.c.should == 1
        @cpu.z.should == 0
        @cpu.n.should == 1

        @cpu.a = 0x99
        @cpu.clc(nil, :imp)
        @cpu.adc(0x00, :imm)
        @cpu.a.should == 0x99
        @cpu.c.should == 0
        @cpu.z.should == 0
        @cpu.n.should == 1

        @cpu.a = 0x99
        @cpu.clc(nil, :imp)
        @cpu.adc(0x01, :imm)
        @cpu.a.should == 0x00
        @cpu.c.should == 1
        @cpu.z.should == 1
        @cpu.n.should == 0

        @cpu.a = 0x00
        @cpu.clc(nil, :imp)
        @cpu.adc(0x00, :imm)
        @cpu.a.should == 0x00
        @cpu.c.should == 0
        @cpu.z.should == 1
        @cpu.n.should == 0

        @cpu.a = 0x99
        @cpu.sec(nil, :imp)
        @cpu.adc(0x00, :imm)
        @cpu.a.should == 0x00
        @cpu.c.should == 1
        @cpu.z.should == 1
        @cpu.n.should == 0
      end

      it "sbc bcd" do
        @cpu.d = 1

        @cpu.a = 0x11
        @cpu.sec(nil, :imp)
        @cpu.sbc(0x02, :imm)
        @cpu.a.should == 0x09
        @cpu.c.should == 1
        @cpu.z.should == 0
        @cpu.n.should == 0

        @cpu.a = 0x01
        @cpu.sec(nil, :imp)
        @cpu.sbc(0x01, :imm)
        @cpu.a.should == 0x00
        @cpu.c.should == 1
        @cpu.z.should == 1
        @cpu.n.should == 0

        @cpu.a = 0x98
        @cpu.sec(nil, :imp)
        @cpu.sbc(0x99, :imm)
        @cpu.a.should == 0x99
        @cpu.c.should == 0
        @cpu.z.should == 0
        @cpu.n.should == 1

        @cpu.a = 0x00
        @cpu.sec(nil, :imp)
        @cpu.sbc(0x32, :imm)
        @cpu.a.should == 0x68
        @cpu.c.should == 0
        @cpu.z.should == 0
        @cpu.n.should == 0

        @cpu.a = 0x00
        @cpu.clc(nil, :imp)
        @cpu.sbc(0x00, :imm)
        @cpu.a.should == 0x99
        @cpu.c.should == 0
        @cpu.z.should == 0
        @cpu.n.should == 1
      end
    end
  end
  describe "Cpu Instructions" do
    before(:each) do
      @mem = Memory.new
      @cpu = Cpu.new(@mem)
    end
    it "adc" do
      @cpu.pc = 0x0100
      @cpu.a = 0x02
      @cpu.adc(0x01, :imm)
      @cpu.a.should == 0x03
      @cpu.pc.should == 0x0102

      @cpu.pc = 0x0100
      @mem.set(0x1000, 0xf0)
      @cpu.adc(0x1000, :abs)
      @cpu.a.should == 0xf3
      @cpu.pc.should == 0x0103
    end
    it "and" do
      @cpu.pc = 0x0100
      @cpu.a = 0xab
      @cpu.and(0x0f, :imm)
      @cpu.a.should == 0x0b
      @cpu.z.should == 0
      @cpu.n.should == 0
      @cpu.pc.should == 0x0102

      @cpu.pc = 0x0100
      @cpu.a = 0xff
      @mem.set(0x0010, 0x00)
      @cpu.and(0x10, :zp)
      @cpu.a.should == 0x00
      @cpu.z.should == 1
      @cpu.n.should == 0
      @cpu.pc.should == 0x0102

      @cpu.a = 0xff
      @mem.set(0x00f0, 0xff)
      @cpu.and(0xf0, :zp)
      @cpu.a.should == 0xff
      @cpu.z.should == 0
      @cpu.n.should == 1
    end
    it "asl" do
      @cpu.pc = 0x0100
      @cpu.a = 0x01
      @cpu.asl(nil, :acc)
      @cpu.a.should == 0x02
      @cpu.z.should == 0
      @cpu.n.should == 0
      @cpu.pc.should == 0x0101

      @cpu.asl(nil, :acc)
      @cpu.asl(nil, :acc)
      @cpu.asl(nil, :acc)
      @cpu.asl(nil, :acc)
      @cpu.asl(nil, :acc)
      @cpu.asl(nil, :acc)
      @cpu.a.should == 0x80
      @cpu.n.should == 1
      @cpu.c.should == 0

      @cpu.asl(nil, :acc)
      @cpu.a.should == 0x00
      @cpu.z.should == 1
      @cpu.n.should == 0
      @cpu.c.should == 1

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

      @cpu.pc = 0x0100
      @cpu.bit(0x3010, :abs)
      @cpu.z.should == 1
      @cpu.a.should == 0x02
      @mem.get(0x3010).should == 0xf1
      @cpu.v.should == 1
      @cpu.n.should == 1
      @cpu.pc.should == 0x0103
    end
    it "dec" do
      @mem.set(0x4010, 0x02)
      @cpu.dec(0x4010, :abs)
      @mem.get(0x4010).should == 0x01
      @cpu.z.should == 0
      @cpu.n.should == 0

      @cpu.pc = 0x0100
      @cpu.dec(0x4010, :abs)
      @mem.get(0x4010).should == 0x00
      @cpu.z.should == 1
      @cpu.n.should == 0
      @cpu.pc.should == 0x0103

      @cpu.dec(0x4010, :abs)
      @mem.get(0x4010).should == 0xff
      @cpu.z.should == 0
      @cpu.n.should == 1
    end
    it "dex" do
      @cpu.x = 0x02
      @cpu.dex(nil, :imp)
      @cpu.x.should == 0x01
      @cpu.z.should == 0
      @cpu.n.should == 0

      @cpu.pc = 0x0100
      @cpu.dex(nil, :imp)
      @cpu.x.should == 0x00
      @cpu.z.should == 1
      @cpu.n.should == 0
      @cpu.pc.should == 0x0101

      @cpu.dex(nil, :imp)
      @cpu.x.should == 0xff
      @cpu.z.should == 0
      @cpu.n.should == 1
    end
    it "dey" do
      @cpu.y = 0x02
      @cpu.dey(nil, :imp)
      @cpu.y.should == 0x01
      @cpu.z.should == 0
      @cpu.n.should == 0

      @cpu.pc = 0x0100
      @cpu.dey(nil, :imp)
      @cpu.y.should == 0x00
      @cpu.z.should == 1
      @cpu.n.should == 0
      @cpu.pc.should == 0x0101

      @cpu.dey(nil, :imp)
      @cpu.y.should == 0xff
      @cpu.z.should == 0
      @cpu.n.should == 1
    end
    it "eor" do
      @mem.set(0x1000, 0x05)
      @cpu.a = 0x06
      @cpu.eor(0x1000, :abs)
      @cpu.a.should == 0x03

      @cpu.pc = 0x0100
      @cpu.a = 0x06
      @cpu.eor(0x05, :imm)
      @cpu.a.should == 0x03
      @cpu.pc.should == 0x0102

      @cpu.a = 0x01
      @cpu.eor(0x01, :imm)
      @cpu.a.should == 0x00
      @cpu.z.should == 1
      @cpu.n.should == 0

      @cpu.eor(0x80, :imm)
      @cpu.a.should == 0x80
      @cpu.z.should == 0
      @cpu.n.should == 1
    end
    it "inc" do
      @mem.set(0x2000, 0x0f)
      @cpu.inc(0x2000, :abs)
      @mem.get(0x2000).should == 0x10
      @cpu.inc(0x2000, :abs)
      @mem.get(0x2000).should == 0x11

      @cpu.pc = 0x0100
      @mem.set(0x00f0, 0xfe)
      @cpu.inc(0xf0, :zp)
      @mem.get(0x00f0).should == 0xff
      @cpu.z.should == 0
      @cpu.n.should == 1
      @cpu.pc.should == 0x0102
      
      @cpu.inc(0xf0, :zp)
      @mem.get(0x00f0).should == 0x00
      @cpu.z.should == 1
      @cpu.n.should == 0

      @cpu.inc(0xf0, :zp)
      @mem.get(0x00f0).should == 0x01
      @cpu.z.should == 0
      @cpu.n.should == 0
    end
    it "inx" do
      @cpu.x = 0x00
      @cpu.inx(nil, :imp)
      @cpu.x.should == 0x01
      @cpu.inx(nil, :imp)
      @cpu.x.should == 0x02

      @cpu.pc = 0x0100
      @cpu.x = 0xfe
      @cpu.inx(nil, :imp)
      @cpu.x.should == 0xff
      @cpu.z.should == 0
      @cpu.n.should == 1
      @cpu.pc.should == 0x0101

      @cpu.inx(nil, :imp)
      @cpu.x.should == 0x00
      @cpu.z.should == 1
      @cpu.n.should == 0

      @cpu.pc = 0x0100
      @cpu.x = 0x81
      @cpu.inx(nil, :imp)
      @cpu.pc.should == 0x0101
      @cpu.x.should == 0x82
      @cpu.z.should == 0
      @cpu.n.should == 1

      @cpu.x = 0xff
      @cpu.inx(nil, :imp)
      @cpu.x.should == 0x00
      @cpu.z.should == 1
      @cpu.n.should == 0
    end
    it "iny" do
      @cpu.y = 0x03
      @cpu.iny(nil, :imp)
      @cpu.y.should == 0x04
      @cpu.iny(nil, :imp)
      @cpu.y.should == 0x05

      @cpu.pc = 0x0100
      @cpu.y = 0xfe
      @cpu.iny(nil, :imp)
      @cpu.y.should == 0xff
      @cpu.z.should == 0
      @cpu.n.should == 1
      @cpu.pc.should == 0x0101

      @cpu.iny(nil, :imp)
      @cpu.y.should == 0x00
      @cpu.z.should == 1
      @cpu.n.should == 0

      @cpu.y = 0x02
      @cpu.iny(nil, :imp)
      @cpu.y.should == 0x03

      @cpu.y = 0xff
      @cpu.iny(nil, :imp)
      @cpu.y.should == 0x00
      @cpu.z.should == 1
      @cpu.n.should == 0
    end
    it "lsr" do
      @cpu.a = 0x05
      @cpu.lsr(nil, :acc)
      @cpu.a.should == 0x02
      @cpu.lsr(nil, :acc)
      @cpu.a.should == 0x01

      @cpu.pc = 0x0100
      @mem.set(0x1010, 0x07)
      @cpu.lsr(0x1010, :abs)
      @mem.get(0x1010).should == 0x03
      @cpu.pc.should == 0x0103

      @cpu.a = 0x02
      @cpu.lsr(nil, :acc)
      @cpu.a.should == 0x01
      @cpu.c.should == 0
      @cpu.z.should == 0
      @cpu.n.should == 0

      @cpu.lsr(nil, :acc)
      @cpu.a.should == 0x00
      @cpu.c.should == 1
      @cpu.z.should == 1
      @cpu.n.should == 0

      @cpu.a = 0xff
      @cpu.lsr(nil, :acc)
      @cpu.a.should == 0x7f
      @cpu.c.should == 1
      @cpu.z.should == 0
      @cpu.n.should == 0
    end
    it "ora" do
      @cpu.a = 0x05
      @mem.set(0x1000, 0x06)
      @cpu.ora(0x1000, :abs)
      @cpu.a.should == 0x07
      
      @cpu.pc = 0x0100
      @cpu.a = 0x05
      @cpu.ora(0x06, :imm)
      @cpu.a.should == 0x07
      @cpu.pc.should == 0x0102

      @cpu.a = 0x01
      @mem.set(0x0040, 0x80)
      @cpu.ora(0x40, :zp)
      @cpu.a.should == 0x81
      @cpu.z.should == 0
      @cpu.n.should == 1

      @cpu.a = 0x00
      @mem.set(0x0040, 0x00)
      @cpu.ora(0x40, :zp)
      @cpu.a.should == 0x00
      @cpu.z.should == 1
      @cpu.n.should == 0
    end
    it "rol" do
      @cpu.pc = 0x0100
      @cpu.a = 0x80
      @cpu.rol(nil, :acc)
      @cpu.a.should == 0x00
      @cpu.c.should == 1
      @cpu.pc.should == 0x0101
      @cpu.rol(nil, :acc)
      @cpu.a.should == 0x01
      @cpu.c.should == 0

      @mem.set(0x900, 0x40)
      @cpu.rol(0x900, :abs)
      @mem.get(0x900).should == 0x80
      @cpu.c.should == 0
      @cpu.z.should == 0
      @cpu.n.should == 1
      @cpu.rol(0x900, :abs)
      @mem.get(0x900).should == 0x00
      @cpu.c.should == 1
      @cpu.z.should == 1
      @cpu.n.should == 0
    end
    it "ror" do
      @cpu.pc = 0x0100
      @cpu.a = 0x01
      @cpu.ror(nil, :acc)
      @cpu.pc.should == 0x0101
      @cpu.a.should == 0x00
      @cpu.z.should == 1
      @cpu.c.should == 1
      @cpu.n.should == 0
      @cpu.ror(nil, :acc)
      @cpu.a.should == 0x80
      @cpu.z.should == 0
      @cpu.c.should == 0
      @cpu.n.should == 1

      @cpu.c = 1
      @mem.set(0x900, 0x80)
      @cpu.ror(0x900, :abs)
      @mem.get(0x900).should == 0xc0
      @cpu.c.should == 0
      @cpu.z.should == 0
      @cpu.n.should == 1
      @cpu.ror(0x900, :abs)
      @mem.get(0x900).should == 0x60
      @cpu.c.should == 0
      @cpu.z.should == 0
      @cpu.n.should == 0
    end
    it "sbc" do
      @cpu.pc = 0x0100
      @cpu.c = 1
      @cpu.a = 0x10
      @mem.set(0x100, 0x0a)
      @cpu.sbc(0x100, :abs)
      @cpu.a.should == 0x06
      @cpu.pc.should == 0x0103

      @cpu.c = 0
      @cpu.a = 0x10
      @cpu.sbc(0x0a, :imm)
      @cpu.a.should == 0x05
    end
    it "nop" do
      @cpu.pc = 0x0100
      @cpu.nop(nil, :imp)
      @cpu.pc.should == 0x0101
    end
    it "sec" do
      @cpu.pc = 0x0100
      @cpu.c = 0
      @cpu.sec(nil, :imp)
      @cpu.c.should == 1
      @cpu.pc.should == 0x0101
    end
    it "sed" do
      @cpu.pc = 0x0100
      @cpu.d = 0
      @cpu.sed(nil, :imp)
      @cpu.d.should == 1
      @cpu.pc.should == 0x0101
    end
    it "sei" do
      @cpu.pc = 0x0100
      @cpu.i = 0
      @cpu.sei(nil, :imp)
      @cpu.i.should == 1
      @cpu.pc.should == 0x0101
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
      @cpu.z  = 1
      @cpu.bne(0x10, :rel)
      @cpu.pc.should == 0x1002

      @cpu.pc = 0x1000
      @cpu.z  = 0
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
    it "brk" do
      @cpu.c = 1
      @cpu.s = 0xff
      @cpu.pc = 0xabcd
      @mem.set(0xfffe, 0x40)
      @mem.set(0xffff, 0x80)
      @cpu.brk(nil, :imp)
      @cpu.pc.should == 0x8040
      @cpu.s.should == 0xfc
      @mem.get(0x01ff).should == 0xab
      @mem.get(0x01fe).should == 0xcd
      @mem.get(0x01fd).should == 0b00110001
    end
    it "rti" do
      @cpu.s = 0xfc
      @mem.set(0x01fd, 0b10100001)
      @mem.set(0x01fe, 0x80)
      @mem.set(0x01ff, 0x40)
      @cpu.rti(nil, :imp)
      @cpu.c.should == 1
      @cpu.n.should == 1
      @cpu.v.should == 0
      @cpu.pc.should == 0x8040
    end
    it "clc" do
      @cpu.pc = 0x0100
      @cpu.c = 1
      @cpu.clc(nil, :imp)
      @cpu.c.should == 0
      @cpu.pc.should == 0x0101

      @cpu.c = 0
      @cpu.clc(nil, :imp)
      @cpu.c.should == 0
    end
    it "cld" do
      @cpu.pc = 0x0100
      @cpu.d = 1
      @cpu.cld(nil, :imp)
      @cpu.d.should == 0
      @cpu.pc.should == 0x0101

      @cpu.d = 0
      @cpu.cld(nil, :imp)
      @cpu.d.should == 0
    end
    it "cli" do
      @cpu.pc = 0x0100
      @cpu.i = 1
      @cpu.cli(nil, :imp)
      @cpu.i.should == 0
      @cpu.pc.should == 0x0101

      @cpu.i = 0
      @cpu.cli(nil, :imp)
      @cpu.i.should == 0
    end
    it "clv" do
      @cpu.pc = 0x0100
      @cpu.v = 1
      @cpu.clv(nil, :imp)
      @cpu.v.should == 0
      @cpu.pc.should == 0x0101

      @cpu.v = 0
      @cpu.clv(nil, :imp)
      @cpu.v.should == 0
    end
    it "cmp" do
      @mem.set(0x1000, 0x10)
      @cpu.a = 0x20
      @cpu.c = 0
      @cpu.z = 1
      @cpu.cmp(0x1000, :abs)
      @cpu.a.should == 0x20
      @cpu.c.should == 1
      @cpu.z.should == 0
      @cpu.n.should == 0

      @cpu.pc = 0x0100
      @cpu.a = 0x10
      @cpu.c = 0
      @cpu.z = 0
      @cpu.cmp(0x10, :imm)
      @cpu.pc.should == 0x0102
      @cpu.a.should == 0x10
      @cpu.c.should == 1
      @cpu.z.should == 1
      @cpu.n.should == 0

      @cpu.a = 0x90
      @cpu.cmp(0x10, :imm)
      @cpu.a.should == 0x90
      @cpu.c.should == 1
      @cpu.z.should == 0
      @cpu.n.should == 1
    end
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
      @cpu.pc = 0x0100
      @cpu.cpx(0x10, :imm)
      @cpu.pc.should == 0x0102
      @cpu.x.should == 0x10
      @cpu.c.should == 1
      @cpu.z.should == 1

      @cpu.x = 0x00
      @cpu.cpx(0x01, :imm)
      @cpu.x.should == 0x00
      @cpu.c.should == 0
      @cpu.z.should == 0
      @cpu.n.should == 1
    end
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
      @cpu.pc = 0x0100
      @cpu.cpy(0x10, :imm)
      @cpu.pc.should == 0x0102
      @cpu.y.should == 0x10
      @cpu.c.should == 1
      @cpu.z.should == 1

      @cpu.y = 0x00
      @cpu.cpy(0x00, :imm)
      @cpu.y.should == 0x00
      @cpu.c.should == 1
      @cpu.z.should == 1
      @cpu.n.should == 0

      @cpu.cpy(0x01, :imm)
      @cpu.c.should == 0
      @cpu.z.should == 0
      @cpu.n.should == 1
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
    it "jsr" do
      @cpu.s = 0xff
      @cpu.pc = 0x0600
      @cpu.jsr(0x1000, :abs)
      @mem.get(0x01ff).should == 0x06
      @mem.get(0x01fe).should == 0x02
      @cpu.pc.should == 0x1000

      @cpu.s = 0xff
      @cpu.pc = 0x06ff
      @cpu.jsr(0x1000, :abs)
      @mem.get(0x01ff).should == 0x07
      @mem.get(0x01fe).should == 0x01
      @cpu.pc.should == 0x1000
    end
    it "rts" do
      @cpu.s = 0xfd
      @mem.set(0x01ff, 0xab)
      @mem.set(0x01fe, 0xcd)
      @cpu.rts(nil, :imp)
      @cpu.pc.should == 0xabce
    end
    it "lda" do
      @cpu.a = 0x66
      @cpu.lda(0x33, :imm)
      @cpu.a.should == 0x33

      @cpu.pc = 0x0100
      @cpu.a = 0x66
      @mem.set( 0x1000, 0x44 )
      @cpu.lda(0x1000, :abs)
      @cpu.a.should == 0x44
      @cpu.pc.should == 0x0103

      @cpu.lda(0x00, :imm)
      @cpu.z.should == 1
      @cpu.n.should == 0

      @cpu.lda(0xff, :imm)
      @cpu.z.should == 0
      @cpu.n.should == 1
    end
    it "ldx" do
      @cpu.x = 0x66
      @cpu.ldx(0x33, :imm)
      @cpu.x.should == 0x33

      @cpu.x = 0x66
      @mem.set( 0x1000, 0x44 )
      @cpu.ldx(0x1000, :abs)
      @cpu.x.should == 0x44

      @cpu.pc = 0x0100
      @cpu.ldx(0x00, :imm)
      @cpu.z.should == 1
      @cpu.n.should == 0
      @cpu.pc.should == 0x0102

      @cpu.ldx(0xff, :imm)
      @cpu.z.should == 0
      @cpu.n.should == 1
    end
    it "ldy" do
      @cpu.y = 0x66
      @cpu.ldy(0x33, :imm)
      @cpu.y.should == 0x33

      @cpu.y = 0x66
      @mem.set( 0x1000, 0x44 )
      @cpu.ldy(0x1000, :abs)
      @cpu.y.should == 0x44

      @cpu.pc = 0x0100
      @cpu.ldy(0x00, :imm)
      @cpu.z.should == 1
      @cpu.n.should == 0
      @cpu.pc.should == 0x0102

      @cpu.ldy(0xff, :imm)
      @cpu.z.should == 0
      @cpu.n.should == 1
    end
    it "pha" do
      @cpu.pc = 0x0100
      @cpu.a = 0x33
      @cpu.s = 0xff
      @cpu.pha(nil, :imp)
      @cpu.s.should == 0xfe
      @mem.get(0x01ff).should == 0x33
      @cpu.pc.should == 0x0101
    end
    it "pla" do
      @cpu.a = 0x66
      @cpu.s = 0xfe
      @mem.set(0x01ff, 0x34)
      @cpu.pla(nil, :imp)
      @cpu.a.should == 0x34
      @cpu.s.should == 0xff
      @cpu.z.should == 0
      @cpu.n.should == 0

      @cpu.pc = 0x0100
      @cpu.s = 0xfe
      @mem.set(0x01ff, 0x00)
      @cpu.pla(nil, :imp)
      @cpu.z.should == 1
      @cpu.n.should == 0
      @cpu.pc.should == 0x0101

      @cpu.s = 0xfe
      @mem.set(0x01ff, 0x80)
      @cpu.pla(nil, :imp)
      @cpu.z.should == 0
      @cpu.n.should == 1
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

      @cpu.pc = 0x0100
      @cpu.s = 0xff
      @cpu.php(nil, :imp)
      @cpu.s.should == 0xfe
      @mem.get( 0x01ff ).should == 0b10110101
      @cpu.pc.should == 0x0101

      @cpu.c = 0
      @cpu.z = 1
      @cpu.i = 0
      @cpu.d = 1
      @cpu.b = 0
      #bit 5   1
      @cpu.v = 1
      @cpu.n = 0

      @cpu.s = 0xfe
      @cpu.php(nil, :imp)
      @cpu.s.should == 0xfd
      @mem.get( 0x01fe ).should == 0b01111010
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

      @cpu.pc = 0x0100
      @mem.set(0x01ff, 0b01101010)
      @cpu.s = 0xfe
      @cpu.plp(nil, :imp)
      @cpu.pc.should == 0x0101
      @cpu.s.should == 0xff

      @cpu.c.should == 0
      @cpu.z.should == 1
      @cpu.i.should == 0
      @cpu.d.should == 1
      @cpu.b.should == 0
      #bit 5           1
      @cpu.v.should == 1
      @cpu.n.should == 0
    end
    it "sta" do
      @cpu.pc = 0x0100
      @cpu.a = 0xfa
      @mem.set( 0x1000, 0xaf )
      @cpu.sta(0x1000, :abs)
      @mem.get( 0x1000 ).should == 0xfa
      @cpu.pc.should == 0x0103
    end
    it "stx" do
      @cpu.pc = 0x0100
      @cpu.x = 0xfa
      @mem.set( 0x1000, 0xaf )
      @cpu.stx(0x1000, :abs)
      @mem.get( 0x1000 ).should == 0xfa
      @cpu.pc.should == 0x0103
    end
    it "sty" do
      @cpu.pc = 0x0100
      @cpu.y = 0xfa
      @mem.set( 0x1000, 0xaf )
      @cpu.sty(0x1000, :abs)
      @mem.get( 0x1000 ).should == 0xfa
      @cpu.pc.should == 0x0103
    end
    it "tax" do
      @cpu.x = 0xea
      @cpu.a = 0xbd
      @cpu.tax(nil, :imp)
      @cpu.a.should == 0xbd
      @cpu.x.should == 0xbd

      @cpu.pc = 0x0100
      @cpu.a = 0x00
      @cpu.tax(nil, :imp)
      @cpu.z.should == 1
      @cpu.n.should == 0
      @cpu.pc.should == 0x0101

      @cpu.a = 0x80
      @cpu.tax(nil, :imp)
      @cpu.z.should == 0
      @cpu.n.should == 1
    end
    it "tay" do
      @cpu.y = 0xea
      @cpu.a = 0xbd
      @cpu.tay(nil, :imp)
      @cpu.a.should == 0xbd
      @cpu.y.should == 0xbd

      @cpu.pc = 0x0100
      @cpu.a = 0x00
      @cpu.tay(nil, :imp)
      @cpu.z.should == 1
      @cpu.n.should == 0
      @cpu.pc.should == 0x0101

      @cpu.a = 0x80
      @cpu.tay(nil, :imp)
      @cpu.z.should == 0
      @cpu.n.should == 1
    end
    it "tsx" do
      @cpu.x = 0xea
      @cpu.s = 0xbd
      @cpu.tsx(nil, :imp)
      @cpu.s.should == 0xbd
      @cpu.x.should == 0xbd

      @cpu.pc = 0x0100
      @cpu.s = 0x00
      @cpu.tsx(nil, :imp)
      @cpu.z.should == 1
      @cpu.n.should == 0
      @cpu.pc.should == 0x0101

      @cpu.s = 0x80
      @cpu.tsx(nil, :imp)
      @cpu.z.should == 0
      @cpu.n.should == 1
    end
    it "txa" do
      @cpu.a = 0xea
      @cpu.x = 0xbd
      @cpu.txa(nil, :imp)
      @cpu.x.should == 0xbd
      @cpu.a.should == 0xbd

      @cpu.pc = 0x0100
      @cpu.x = 0x00
      @cpu.txa(nil, :imp)
      @cpu.z.should == 1
      @cpu.n.should == 0
      @cpu.pc.should == 0x0101

      @cpu.x = 0x80
      @cpu.txa(nil, :imp)
      @cpu.z.should == 0
      @cpu.n.should == 1
    end
    it "txs" do
      @cpu.pc = 0x0100
      @cpu.s = 0xea
      @cpu.x = 0xbd
      @cpu.txs(nil, :imp)
      @cpu.x.should == 0xbd
      @cpu.s.should == 0xbd
      @cpu.pc.should == 0x0101
    end
    it "tya" do
      @cpu.a = 0xea
      @cpu.y = 0xbd
      @cpu.tya(nil, :imp)
      @cpu.y.should == 0xbd
      @cpu.a.should == 0xbd

      @cpu.pc = 0x0100
      @cpu.y = 0x00
      @cpu.tya(nil, :imp)
      @cpu.z.should == 1
      @cpu.n.should == 0
      @cpu.pc.should == 0x0101

      @cpu.y = 0x80
      @cpu.tya(nil, :imp)
      @cpu.z.should == 0
      @cpu.n.should == 1
    end
  end
end
