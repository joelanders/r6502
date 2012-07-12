module R6502
  class Memory
    def initialize
      @mem_array = []
    end
    def set( addr, val )
      @mem_array[addr] = val & 0xff
    end
    def get( addr )
      @mem_array[addr] || 0
    end
    def get_word( addr )
      get(addr) + ( get(addr + 1) << 8 )
    end
    def get_range( top, bot )
      bytes = []
      (top..bot).each { |i| bytes << get(i) }
      bytes
    end
  end
end
