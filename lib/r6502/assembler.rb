module R6502
  class Assembler

    def initialize(memory)
      @memory = memory
      @pc = 0x600
      @labels = {}
    end

    def pc
      @pc
    end

    def labels
      @labels
    end

    def label_get(label)
      @labels[label]
    end

    def uncomment(line)
      line.sub(/\s*;.*/, '')
    end

    def extract_command(instr)
      instr.sub(/\s.*/, '').to_sym
    end

    def extract_param(instr)
      instr.sub(/.*\s+/, '')
    end

    def addr_mode(param)
      case param
      when /#\$[0-9a-f]{1,2}$/
        :imm
      when /\$[0-9a-f]{1,2}$/
        :zp
      when /\$[0-9a-f]{1,2},x$/
        :zpx
      when /\$[0-9a-f]{1,2},y$/
        :zpy
      when /\$[0-9a-f]{3,4}$/
        :abs
      when /\$[0-9a-f]{3,4},x$/
        :absx
      when /\$[0-9a-f]{3,4},y$/
        :absy
      when /\(\$[0-9a-f]{3,4}\)$/
        :ind
      when /\(\$[0-9a-f]{1,2},x\)$/
        :indx
      when /\(\$[0-9a-f]{1,2}\),y$/
        :indy
      when //
        :imp
      end
    end

    # This method got nasty.
    def asm_instr(instr)
      command = extract_command(instr)
      param = extract_param(instr)

      # Branch instructions always in relative
      # mode. No other instructions use this mode.
      # Relative mode and zero-page mode look the
      # same to addr_mode(), so we need to handle
      # this here.
      if [:bpl, :bmi, :bvc, :bvs,
          :bcc, :bcs, :bne, :beq].
         include?(command)
        mode = :rel
      else
        mode = addr_mode(param)
      end

      bytes = []
      bytes << opcode(command, mode)

      # If implied mode, it's a 1-byte instruction.
      if [:imp].include?(mode)
        return bytes
      end

      # Extract hex number from param string.
      number = /[0-9a-f]{1,4}/.match(param)[0].to_i(16)

      # These instructions take 1 byte.
      if [:imm,  :zp,   :zpx,  :zpy,
          :indx, :indy, :rel].include?(mode)
        (number < 0xff) || (raise 'number too big')
        return bytes << number
      # These instructions take 2 bytes.
      elsif [:abs, :absx, :absy, :ind].include?(mode)
        (number < 0xffff) || (raise 'number too big')
        bytes << (number & 0xff) # least-sig. byte
        bytes << (number >> 8)   # most-sig. byte
      end
    end

    def write_byte(byte)
      @memory.set(@pc, byte)
      @pc += 1
    end

    def process_line(line)     # can have label, cmd, param, cmt
      instr = uncomment(line)  # strips comment
      instr = delabel(instr)   # strips label
      if instr == '' then return end
      bytes = asm_instr(instr) # convert remainder to machine code
      bytes.each { |b| write_byte(b) } # pop bytes into memory
    end

    def delabel(instr)
      instr = instr.sub(/^\s+/, '') #strip leading whitespace
      first = instr.split(/\s+/)[0] #get first non-ws substr.
      # if first word is an instruction, then there's
      # no label in this instr, so we're done.
      if ['adc', 'and', 'asl', 'bit', 'bpl', 'bmi',
          'bvc', 'bvs', 'bcc', 'bcs', 'bne', 'beq',
          'brk', 'cmp', 'cpx', 'cpy', 'dec', 'eor',
          'clc', 'sec', 'cli', 'sei', 'clv', 'cld',
          'sed', 'inc', 'jmp', 'jsr', 'lda', 'ldx',
          'ldy', 'lsr', 'nop', 'ora', 'tax', 'txa',
          'dex', 'inx', 'tay', 'tya', 'dey', 'iny',
          'ror', 'rol', 'rti', 'rts', 'sbc', 'sta',
          'txs', 'tsx', 'pha', 'pla', 'php', 'plp',
          'stx', 'sty', 'nil'].include?(first) || first == nil
        return instr
      end

      # otherwise, it is a label.
      first = /\w+/.match(first)[0]
      new_label(first)

      return instr.sub(/^\S+\s*/, '') # rm label from instr
    end

    def new_label(name)
      @labels.member?(name) && (raise 'label already defined')
      @labels[name] = @pc
    end

  end
end

