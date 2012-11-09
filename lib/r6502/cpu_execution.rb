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
  end
end
