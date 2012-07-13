require 'spec_helper'

module R6502
  describe Assembler do
    before(:each) do
      @mem = Memory.new
      @asm = Assembler.new(@mem)
    end

    it "removes comment and trailing whitespace" do
      @asm.uncomment('nop ; comment here').should == 'nop'
      @asm.uncomment('lda #$ff; com').should == 'lda #$ff'
    end

    it "extracts command part of line" do
      @asm.extract_command('nop').should == :nop
      @asm.extract_command(' nop').should == :nop
      @asm.extract_command('adc \($44\),y').should == :adc
      @asm.extract_command('asl   $0100').should == :asl
    end

    it "extracts parameter part of line" do
      @asm.extract_param('and $abcd,x').should == '$abcd,x'
      @asm.extract_param('cmd    \($bb,x\)').should == '\($bb,x\)'
      @asm.extract_param('nop').should == ''
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
        @asm.addr_mode('loop').should == :abs
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

    describe "assemble an instruction" do
      it "implied" do
        @asm.asm_instr('nop').should == [0xea]
        @asm.asm_instr('asl').should == [0x0a]
      end
      it "absolute" do
        @asm.asm_instr('lda $dcba').should == [0xad, 0xba, 0xdc]
      end
      it "absolute, x" do
        @asm.asm_instr('adc $cbad,x').should == [0x7d, 0xad, 0xcb]
      end
      it "absolute y" do
        @asm.asm_instr('and $badc,y').should == [0x39, 0xdc, 0xba]
      end
      it "immediate" do
        @asm.asm_instr('lda #$aa').should == [0xa9, 0xaa]
      end
      it "zero page" do
        @asm.asm_instr('asl $10').should == [0x06, 0x10]
      end
      it "zero page, x" do
        @asm.asm_instr('cmp $36,x').should == [0xd5, 0x36]
      end
      it "zero page, y" do
        @asm.asm_instr('ldx $63,y').should == [0xb6, 0x63]
      end
      it "indirect" do
        @asm.asm_instr('jmp ($fffe)').should == [0x6c, 0xfe, 0xff]
      end
      it "indirect, x" do
        @asm.asm_instr('eor ($10,x)').should == [0x41, 0x10]
      end
      it "indirect, y" do
        @asm.asm_instr('ora ($20),y').should == [0x11, 0x20]
      end
      it "relative" do
        @asm.asm_instr('bne $12').should == [0xd0, 0x12]
      end
    end

    describe "assembles and writes lines to memory" do
      it "starts with pc = 0x600" do
        @asm.pc.should == 0x600
      end
      it "processes a 1-byte instruction" do
        @asm.process_line('nop ; comment')
        @asm.pc.should == 0x601
        @mem.get(0x600).should == 0xea
      end
      it "processes a mixed-case 1-byte instruction" do
        @asm.process_line('NOp ; comment')
        @asm.pc.should == 0x601
        @mem.get(0x600).should == 0xea
      end
      it "processes a 2-byte instruction" do
        @asm.process_line('lda #$6c')
        @asm.pc.should == 0x602
        @mem.get_range(0x600, 0x601).should == [0xa9, 0x6c]
      end
      it "processes a 3-byte instruction" do
        @asm.process_line('inc $2001')
        @asm.pc.should == 0x603
        @mem.get_range(0x600, 0x602).should == [0xee, 0x01, 0x20]
      end
      it "processes a few instructions" do
        @asm.process_line('nop')
        @asm.process_line('asl')
        @asm.process_line('ldx $55')
        @asm.pc.should == 0x604
        @mem.get_range(0x600, 0x603).should == [0xea, 0x0a, 0xa6, 0x55]
      end
      it "processes instructions with leading labels" do
        @asm.process_line('top: nop')
        @asm.process_line('second: asl')
        @asm.process_line('third ldx $55')
        @asm.process_line('fourth')
        @asm.pc.should == 0x604
        @mem.get_range(0x600, 0x603).should == [0xea, 0x0a, 0xa6, 0x55]
        @asm.label_get('top').should == 0x600
        @asm.label_get('second').should == 0x601
        @asm.label_get('third').should == 0x602
        @asm.label_get('fourth').should == 0x604
      end
      it "processes instructions with referenced-to labels" do
        @asm.process_line('jmp cleanup')
        @mem.get_range(0x600, 0x602).should == [0x4c, 0xff, 0xff]
        @asm.deferred.should == {0x601 => 'cleanup'}
        @asm.pc.should == 0x603
      end
    end

    describe "remove labels" do
      it "removes label from an assembly instr" do
        @asm.delabel('loop: brk').should == 'brk'
        @asm.delabel('scoop:').should == ''
        @asm.delabel('').should == ''
        @asm.delabel(' ').should == ''
        @asm.delabel('  lda $2000').should == 'lda $2000'
        @asm.delabel('doop  lda $2000').should == 'lda $2000'
      end
    end
    describe "record labels" do
      it "records that label and its address" do
        @asm.delabel('loop: nop').should == 'nop'
        @asm.labels.should == {'loop' => 0x600}
        @asm.label_get('loop').should == 0x600
      end
    end

    describe "record pending labels" do
      it "records mem. bytes whose values we don't know yet" do
        @asm.defer_value(0x601, 'main')
        @asm.deferred.should == {0x601 => 'main'}
      end
    end

    describe "process a file (many lines)" do
      it "places the machine code and figures out the labels" do
        @asm.process_file("lda $2000 ;cmt\nloop nop\njmp loop\n")
        @mem.get_range(0x600, 0x602).should == [0xad, 0x00, 0x20]
        @mem.get_range(0x603, 0x606).should == [0xea, 0x4c, 0x03, 0x06]
      end
    end

  end
end
