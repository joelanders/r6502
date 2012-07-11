require 'spec_helper'

module R6502
  describe Assembler do
    before(:each) do
      @asm = Assembler.new
    end

    it "initializes program counter to 0x600" do
      @asm.pc.should == 0x600
    end

    it "assembles 'nop' to 0xea" do
      @asm.parse('nop').should == 0xea
    end

    it "determines addressing mode of a line" do
    end

    it "removes comment and trailing whitespace" do
      @asm.uncomment('nop ; comment here').should == 'nop'
      @asm.uncomment('lda #$ff; com').should == 'lda #$ff'
    end

    it "extracts command part of line" do
      @asm.extract_command('nop').should == 'nop'
      @asm.extract_command('adc \($44\),y').should == 'adc'
      @asm.extract_command('asl   $0100').should == 'asl'
    end

    it "extracts parameter part of line" do
      @asm.extract_param('and $abcd,x').should == '$abcd,x'
      @asm.extract_param('cmd    \($bb,x\)').should == '\($bb,x\)'
    end

    describe "determine addressing mode" do
      it "immediate" do
        @asm.addr_mode('#$10').should == :imm
        @asm.addr_mode('#$4').should == :imm
      end
      it "zero page" do
        @asm.addr_mode('$20').should == :zp
        @asm.addr_mode('$2').should == :zp
      end
      it "zero page, x" do
        @asm.addr_mode('$30,x').should == :zpx
        @asm.addr_mode('$3,x').should == :zpx
      end
      it "absolute" do
        @asm.addr_mode('$ffff').should == :abs
        @asm.addr_mode('$eee').should == :abs
      end
      it "absolute, x" do
        @asm.addr_mode('$1000,x').should == :absx
        @asm.addr_mode('$800,x').should == :absx
      end
      it "absolute, y" do
        @asm.addr_mode('$4000,y').should == :absy
        @asm.addr_mode('$f00,y').should == :absy
      end
      it "indirect, x" do
        @asm.addr_mode('($de,x)').should == :indx
        @asm.addr_mode('($b,x)').should == :indx
      end
      it "indirect, y" do
        @asm.addr_mode('($ed),y').should == :indy
        @asm.addr_mode('($e),y').should == :indy
      end
    end

  end
end
