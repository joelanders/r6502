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
      m = @mem.get( arg_and_mode[:arg] )
      a = @a
      result = a & m
      @z = 1 if result == 0
      @o = (m & 0x40)>>6
      @n = (m & 0x80)>>7
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
    def sec(arg_and_mode)
      @c = 1
    end
    def sed(arg_and_mode)
      @d = 1
    end
    def sei(arg_and_mode)
      @i = 1
    end
    def bcc(arg_and_mode)
      inc_pc_by_mode(:rel)
      @pc += arg_and_mode[:arg] if @c == 0
    end
    def bcs(arg_and_mode)
      inc_pc_by_mode(:rel)
      @pc += arg_and_mode[:arg] if @c == 1
    end
    def beq(arg_and_mode)
      inc_pc_by_mode(:rel)
      @pc += arg_and_mode[:arg] if @z == 1
    end
    def bmi(arg_and_mode)
      inc_pc_by_mode(:rel)
      @pc += arg_and_mode[:arg] if @n == 1
    end
    def bne(arg_and_mode)
      inc_pc_by_mode(:rel)
      @pc += arg_and_mode[:arg] if @z == 1
    end
    def bpl(arg_and_mode)
      inc_pc_by_mode(:rel)
      @pc += arg_and_mode[:arg] if @n == 0
    end
    def bvc(arg_and_mode)
      inc_pc_by_mode(:rel)
      @pc += arg_and_mode[:arg] if @o == 0
    end
    def bvs(arg_and_mode)
      inc_pc_by_mode(:rel)
      @pc += arg_and_mode[:arg] if @o == 1
    end
    def clc()
      @c = 0
    end
    def cld()
      @d = 0
    end
    def cli()
      @i = 0
    end
    def clv()
      @o = 0
    end
    def cmp( arg_and_mode )
      case arg_and_mode[:mode]
      when :imm
        result = @a - arg_and_mode[:arg]
        @c = result >= 0 ? 1 : 0
        @z = result == 0 ? 1 : 0
        #TODO negative flag
      else
        m = @mem.get( arg_and_mode[:arg] )
        result = @a - m
        @c = result >= 0 ? 1 : 0
        @z = result == 0 ? 1 : 0
        #TODO negative flag
      end
    end
    def cpx( arg_and_mode )
      case arg_and_mode[:mode]
      when :imm
        result = @x - arg_and_mode[:arg]
        @c = result >= 0 ? 1 : 0
        @z = result == 0 ? 1 : 0
        #TODO negative flag
      else
        m = @mem.get( arg_and_mode[:arg] )
        result = @x - m
        @c = result >= 0 ? 1 : 0
        @z = result == 0 ? 1 : 0
        #TODO negative flag
      end
    end
    def cpy( arg_and_mode )
      case arg_and_mode[:mode]
      when :imm
        result = @y - arg_and_mode[:arg]
        @c = result >= 0 ? 1 : 0
        @z = result == 0 ? 1 : 0
        #TODO negative flag
      else
        m = @mem.get( arg_and_mode[:arg] )
        result = @y - m
        @c = result >= 0 ? 1 : 0
        @z = result == 0 ? 1 : 0
        #TODO negative flag
      end
    end
    def jmp( arg_and_mode )
      case arg_and_mode[:mode]
      when :abs
        @pc = arg_and_mode[:arg]
      else #indirect
        lsb = @mem.get( arg_and_mode[:arg] )
        msb = @mem.get( arg_and_mode[:arg] + 1)
        @pc = lsb + msb<<8
      end
    end
    def lda( arg_and_mode )
      case arg_and_mode[:mode]
      when :imm
        @a = arg_and_mode[:arg]
      else
        @a = @mem.get( arg_and_mode[:arg] )
      end
    end
    def ldx( arg_and_mode )
      case arg_and_mode[:mode]
      when :imm
        @x = arg_and_mode[:arg]
      else
        @x = @mem.get( arg_and_mode[:arg] )
      end
    end
    def ldy( arg_and_mode )
      case arg_and_mode[:mode]
      when :imm
        @y = arg_and_mode[:arg]
      else
        @y = @mem.get( arg_and_mode[:arg] )
      end
    end
    def pha()
      addr = 0x0100 + (0xff & @s)
      @mem.set( addr, @a )
      @s -= 1
    end
    def pla()
      addr = 0x0100 + (0xff & (@s + 1))
      @a = @mem.get( addr )
      @s += 1
    end
    def php()
      addr = 0x0100 + (0xff & @s)
      val =            @n #bit 7
      val = (val<<1) + @o #bit 6
      val = (val<<1) +  1 #bit 5
      val = (val<<1) + @b #bit 4
      val = (val<<1) + @d #bit 3
      val = (val<<1) + @i #bit 2
      val = (val<<1) + @z #bit 1
      val = (val<<1) + @c #bit 0

      @mem.set( addr, val )
      @s -= 1
    end
    def plp()
      addr = 0x0100 + (0xff & (@s + 1))
      val = @mem.get( addr )
      @c = 0x1 & val
      @z = 0x1 & (val>>1)
      @i = 0x1 & (val>>2)
      @d = 0x1 & (val>>3)
      @b = 0x1 & (val>>4)
      # bit 5
      @o = 0x1 & (val>>6)
      @n = 0x1 & (val>>7)
    end
    def sta( arg_and_mode )
      @mem.set( arg_and_mode[:arg], @a )
    end
    def stx( arg_and_mode )
      @mem.set( arg_and_mode[:arg], @x )
    end
    def sty( arg_and_mode )
      @mem.set( arg_and_mode[:arg], @y )
    end
    def tax()
      @x = @a
    end
    def tay()
      @y = @a
    end
    def tsx()
      @x = @s
    end
    def txa()
      @a = @x
    end
    def txs()
      @s = @x
    end
    def tya()
      @a = @y
    end
  end
end
