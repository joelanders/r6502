module R6502
  class Cpu
    # add with carry
    # DEPENDS ON DECIMAL FLAG
    # TODO
    def adc(a1, a2)
      a1 + a2
    end
    # logical and
    def and(a1, a2)
      a1 & a2
    end
    # shift left
    def asl(a)
      a<<1
    end
    # logical and (result discarded)
    def bit(a1, a2)
      a1 & a2
    end
    # decrement (memory)
    def dec(a)
      a - 1
    end
    # decrement (x)
    def dex(a)
      a - 1
    end
    # decrement (y)
    def dey(a)
      a - 1
    end
    # exclusive or
    def eor(a1, a2)
      a1 ^ a2
    end
    # increment (memory)
    def inc(a)
      a + 1
    end
    # increment (x)
    def inx(a)
      a + 1
    end
    # increment (y)
    def iny(a)
      a + 1
    end
    # shift right
    def lsr(a)
      a>>1
    end
    # inclusive or
    def ora(a1, a2)
      a1 | a2
    end
    # rotate left
    def rol(a)
      (0xff & (a<<1)) | ((0x80 & a)>>7)
    end
    # rotate right
    def ror(a)
      (a>>1) | ((0x01 & a)<<7)
    end
    # subtract with carry
    # DEPENDS ON DECIMAL FLAG
    # TODO
    def sbc(a1, a2)
      (0xff & (a1 - a2))
    end
  end
end
