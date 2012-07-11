module R6502
  class Assembler

    def initialize
      @pc = 0x600
    end

    def pc
      @pc
    end

    def parse(command)
      0xea
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
    def asm_line(line)
      instr = uncomment(line)
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

  end
end
