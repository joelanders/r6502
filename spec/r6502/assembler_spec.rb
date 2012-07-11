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
      @asm.extract_command('nop').should == :nop
      @asm.extract_command('adc \($44\),y').should == :adc
      @asm.extract_command('asl   $0100').should == :asl
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
      it "zero page, y" do
        @asm.addr_mode('$40,y').should == :zpy
        @asm.addr_mode('$4,y').should == :zpy
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
      it "indirect" do
        @asm.addr_mode('($deca)').should == :ind
        @asm.addr_mode('($dec)').should == :ind
      end
      it "indirect, x" do
        @asm.addr_mode('($de,x)').should == :indx
        @asm.addr_mode('($b,x)').should == :indx
      end
      it "indirect, y" do
        @asm.addr_mode('($ed),y').should == :indy
        @asm.addr_mode('($e),y').should == :indy
      end
      it "implied" do
        @asm.addr_mode('').should == :imp
      end
    end

    it "figures out the opcode" do
      @asm.opcode(:lda, :imm).should == 0xa9
      @asm.opcode(:lda, :zp).should == 0xa5
      @asm.opcode(:nop, :imp).should == 0xea
    end

    describe "assemble a line" do
      it "implied" do
        @asm.asm_line('nop').should == [0xea]
        @asm.asm_line('nop ; a comment').should == [0xea]
        @asm.asm_line('asl').should == [0x0a]
      end
      it "absolute" do
        @asm.asm_line('lda $dcba').should == [0xad, 0xba, 0xdc]
        @asm.asm_line('lda $dcba ; a comment').should == [0xad, 0xba, 0xdc]
      end
      it "absolute, x" do
        @asm.asm_line('adc $cbad,x').should == [0x7d, 0xad, 0xcb]
      end
      it "absolute y" do
        @asm.asm_line('and $badc,y').should == [0x39, 0xdc, 0xba]
      end
      it "immediate" do
        @asm.asm_line('lda #$aa').should == [0xa9, 0xaa]
      end
      it "zero page" do
        @asm.asm_line('asl $10').should == [0x06, 0x10]
      end
      it "zero page, x" do
        @asm.asm_line('cmp $36,x').should == [0xd5, 0x36]
      end
      it "zero page, y" do
        @asm.asm_line('ldx $63,y').should == [0xb6, 0x63]
      end
      it "indirect" do
        @asm.asm_line('jmp ($fffe)').should == [0x6c, 0xfe, 0xff]
      end
      it "indirect, x" do
        @asm.asm_line('eor ($10,x)').should == [0x41, 0x10]
      end
      it "indirect, y" do
        @asm.asm_line('ora ($20),y').should == [0x11, 0x20]
      end
      it "relative" do
        @asm.asm_line('bne $12').should == [0xd0, 0x12]
      end
    end

  end
end
