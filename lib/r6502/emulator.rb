module R6502
  class Emulator
    attr_accessor :pc, :s, :p, :a, :x, :y, :mem
    def initialize
      @mem = Memory.new
    end

  end
end
