module R6502
  class Emulator
    attr_accessor :pc, :s, :p, :a, :x, :y, :mem, :cpu
    def initialize
      @mem = Memory.new
      @cpu = Cpu.new(@mem)
    end
  end
end
