module R6502
  class Cpu
    # add with carry
    # DEPENDS ON DECIMAL FLAG
    # TODO
    def adc(arg_and_mode)
      @a = @a + arg_and_mode[:arg]
    end
    # logical and
    def and(arg_and_mode)
      @a = @a & arg_and_mode[:arg]
    end
    # shift left
    def asl(arg_and_mode)
      case arg_and_mode[:mode]
      when :acc
        @a = @a<<1
      else
        @mem.set( arg_and_mode[:arg], @mem.get(arg_and_mode[:arg])<<1 )
      end
    end
    # logical and (result discarded)
    def bit(arg_and_mode)
      a1 & a2
    end
    # decrement (memory)
    def dec(arg_and_mode)
      @mem.set( arg_and_mode[:arg], @mem.get(arg_and_mode[:arg]) - 1 )
    end
    # decrement (x)
    def dex(arg_and_mode)
      @x -= 1
    end
    # decrement (y)
    def dey(arg_and_mode)
      @y -= 1
    end
    # exclusive or
    def eor(arg_and_mode)
      case arg_and_mode[:mode]
      when :imm
        @a = @a ^ arg_and_mode[:arg]
      else
        @a = @a ^ @mem.get(arg_and_mode[:arg])
      end
    end
    # increment (memory)
    def inc(arg_and_mode)
      @mem.set( arg_and_mode[:arg], @mem.get(arg_and_mode[:arg]) + 1 )
    end
    # increment (x)
    def inx(arg_and_mode)
      @x += 1
    end
    # increment (y)
    def iny(arg_and_mode)
      @y += 1
    end
    # shift right
    def lsr(arg_and_mode)
      case arg_and_mode[:mode]
      when :acc
        @a = @a>>1
      else
        @mem.set( arg_and_mode[:arg], @mem.get(arg_and_mode[:arg]) >> 1 )
      end
    end
    # inclusive or
    def ora(arg_and_mode)
      case arg_and_mode[:mode]
      when :imm
        @a = @a | arg_and_mode[:arg]
      else
        @a = @a | @mem.get( arg_and_mode[:arg] )
      end
    end
    # rotate left
    def rol(arg_and_mode)
      case arg_and_mode[:mode]
      when :acc
        @a = (0xff & (@a<<1)) | ((0x80 & @a)>>7)
      else
        val = @mem.get(arg_and_mode[:arg])
        val = (0xff & (val<<1)) | ((0x80 & val)>>7)
        @mem.set(arg_and_mode[:arg], val)
      end
    end
    # rotate right
    def ror(arg_and_mode)
      #(a>>1) | ((0x01 & a)<<7)
      case arg_and_mode[:mode]
      when :acc
        @a = (@a>>1) | ((0x01 & @a)<<7)
      else
        val = @mem.get(arg_and_mode[:arg])
        val = (val>>1) | ((0x01 & val)<<7)
        @mem.set(arg_and_mode[:arg], val)
      end
    end
    # subtract with carry
    # DEPENDS ON DECIMAL FLAG
    # TODO
    def sbc(arg_and_mode)
      case arg_and_mode[:mode]
      when :imm
        val = arg_and_mode[:arg]
        @a = (0xff & (@a - val))
      else
        val = @mem.get( arg_and_mode[:arg] )
        @a = (0xff & (@a - val))
      end
    end
    # no operation
    def nop(arg_and_mode)
      @pc += 1
    end
  end
end
