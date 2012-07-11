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
      instr.sub(/\s.*/, '')
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
      when /\$[0-9a-f]{3,4}$/
        :abs
      when /\$[0-9a-f]{3,4},x$/
        :absx
      when /\$[0-9a-f]{3,4},y$/
        :absy
      when /\(\$[0-9a-f]{1,2},x\)$/
        :indx
      when /\(\$[0-9a-f]{1,2}\),y$/
        :indy
      end
    end

  end
end
