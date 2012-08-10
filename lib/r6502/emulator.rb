module R6502
  class Emulator
    attr_accessor :pc, :s, :p, :a, :x, :y, :mem
    def initialize
      @mem = Memory.new
    end
    def arg(mode, sec_word, thd_word)
      case mode
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
      end
    end

  end
end
