module R6502
  class Emulator
    attr_accessor :pc, :s, :p, :a, :x, :y, :mem, :cpu
    def initialize
      @mem = Memory.new
      @cpu = Cpu.new(@mem)
    end
    def arg(mode, sec_word, thd_word)
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
