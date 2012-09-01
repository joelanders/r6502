require 'spec_helper'

module R6502
  describe Cpu do
    before(:each) do
      @cpu = Cpu.new
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
      @cpu.adc(0x01, 0x0f).should == 0x10
    end
    it "and" do
      @cpu.and(0xab, 0x0f).should == 0x0b
    end
    it "asl" do
      @cpu.asl(0x01).should == 0x02
    end
    it "bit" do
      @cpu.bit(0x01, 0x02).should == 0x00
    end
    it "dec" do
      @cpu.dec(0x10).should == 0x0f
    end
    it "dex" do
      @cpu.dex(0x02).should == 0x01
    end
    it "dey" do
      @cpu.dey(0x03).should == 0x02
    end
    it "eor" do
      @cpu.eor(0x05, 0x06).should == 0x03
    end
    it "inc" do
      @cpu.inc(0x10).should == 0x11
    end
    it "inx" do
      @cpu.inx(0x02).should == 0x03
    end
    it "iny" do
      @cpu.iny(0x03).should == 0x04
    end
    it "lsr" do
      @cpu.lsr(0x05).should == 0x02
    end
    it "ora" do
      @cpu.ora(0x05, 0x06).should == 0x07
    end
    it "rol" do
      @cpu.rol(0x80).should == 0x01
      @cpu.rol(0x01).should == 0x02
      @cpu.rol(0x81).should == 0x03
      @cpu.rol(0xff).should == 0xff
    end
    it "ror" do
      @cpu.ror(0x01).should == 0x80
    end
    # DEPENDS ON DECIMAL FLAG
    # TODO
    it "sbc" do
      @cpu.sbc(0x10, 0x0a).should == 0x06
    end
  end
end
