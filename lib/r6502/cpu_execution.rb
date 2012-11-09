module R6502
  class Cpu
    attr_accessor :mem, :pc, :s, :x, :y, :a
    def initialize(mem)
      @mem = mem
      @pc = @mem.get_word(0xfffc)
      @s  = 0xff
      @x  = 0x00
      @y  = 0x00
      @a  = 0x00
    end
    def step
      i_m = instr_mode( mem.get(pc) )
      arg = decode_arg( i_m[:mode], mem.get(pc+1), mem.get(pc+2) )
      arg_and_mode = {arg: arg, mode: i_m[:mode]}

      method( i_m[:instr] ).call( arg_and_mode )
    end
    def decode_arg(mode, sec_word, thd_word)
      case mode
      when :imp
          nil
      when :imm
        sec_word
      when :zp
        sec_word
      when :zpx
        sec_word + @x
      when :zpy
        sec_word + @y
      when :rel
        sec_word +@pc
      when :abs
        (thd_word<<8) + sec_word
      when :absx
        (thd_word<<8) + sec_word + @x
      when :absy
        (thd_word<<8) + sec_word + @y
      when :ind
        lb = @mem.get( (thd_word<<8) + sec_word )
        hb = @mem.get( (thd_word<<8) + sec_word + 1 )
        (hb<<8) + lb
      when :indx
        lb = @mem.get( 0xff & (@x + sec_word) )
        hb = @mem.get( 0xff & (@x + sec_word) + 1 )
        @mem.get( (hb<<8) + lb )
      when :indy
        lb = @mem.get( 0xff & sec_word )
        hb = @mem.get( 0xff & sec_word + 1)
        addr = (hb<<8) + lb
        @mem.get( addr + @y )
      end
    end
  end
end
