module R6502
  class Cpu
    # add with carry
    def adc(arg, mode)
      x = @a
      y = mode == :imm ? arg : @mem.get(arg)
      if @d == 0 #normal binary mode
        r = x + y + @c
        @a = 0xff & r
        @v = (((0x7f&x) + (0x7f&y) + @c)>>7) ^ ((x + y + @c)>>8)
        @z = (r&0xff).zero? ? 1 : 0
        @c = r > 255 ? 1 : 0
        @n = (0x80&r)>>7
      else #BCD mode
        ones = (0xf&x) + (0xf&y)
        tens = ((0xf0&x)>>4) + ((0xf0&y)>>4)
        r0 = ones + 10*tens + @c
        @c = r0 > 99 ? 1 : 0
        r = r0 % 100
        @z = r.zero? ? 1 : 0
        @a = r + 6*((r/10).floor)
        @n = (0x80&@a)>>7
      end
    end
    # subtract with carry
    def sbc(arg, mode)
      x = @a
      y = mode == :imm ? arg : @mem.get(arg)
      if @d == 0 #normal binary mode
        y = (y^0xff)
        r = x + y + @c
        @a = 0xff & r
        @v = (((0x7f&x) + (0x7f&y) + @c)>>7) ^ ((x + y + @c)>>8)
        @z = (0xff&r).zero? ? 1 : 0
        @c = r > 255 ? 1 : 0
        @n = (0x80&r)>>7
      else #BCD mode
        ones = (0xf&x) - (0xf&y)
        tens = ((0xf0&x)>>4) - ((0xf0&y)>>4)
        r0 = ones + 10*tens - (1 - @c)
        @c = r0 >= 0 ? 1 : 0
        r = r0 % 100
        @z = r.zero? ? 1 : 0
        @a = r + 6*((r/10).floor)
        @n = (0x80&@a)>>7
      end
    end
    # logical and
    def and(arg, mode)
      case mode
      when :imm
        @a = @a & arg
      else
        @a = @a & @mem.get(arg)
      end
      @z = @a.zero? ? 1 : 0
      @n = @a>>7
    end
    # shift left
    def asl(arg, mode)
      case mode
      when :acc
        r = @a<<1
        @a = r&0xff
        @z = @a.zero? ? 1 : 0
        @n = @a>>7
        @c = r > 0xff ? 1 : 0
      else
        r = @mem.get(arg)<<1
        @mem.set( arg, r&0xff )
        @z = r.zero? ? 1 : 0
        @n = r>>7
        @c = r > 0xff ? 1 : 0
      end
    end
    # logical and (result discarded)
    def bit(arg, mode)
      m = @mem.get( arg )
      a = @a
      result = a & m
      @z = result.zero? ? 1 : 0
      @v = (m & 0x40)>>6
      @n = (m & 0x80)>>7
    end
    # decrement (memory)
    def dec(arg, mode)
      r = @mem.get(arg) - 1
      @mem.set( arg, r&0xff )
      @z = r.zero? ? 1 : 0
      @n = (r&0x80)>>7
    end
    # decrement (x)
    def dex(arg, mode)
      r = @x - 1
      @x = r&0xff
      @z = @x.zero? ? 1 : 0
      @n = (@x&0x80)>>7
    end
    # decrement (y)
    def dey(arg, mode)
      r = @y - 1
      @y = r&0xff
      @z = @y.zero? ? 1 : 0
      @n = (@y&0x80)>>7
    end
    # exclusive or
    def eor(arg, mode)
      case mode
      when :imm
        @a = @a ^ arg
      else
        @a = @a ^ @mem.get(arg)
      end
      @z = @a.zero? ? 1 : 0
      @n = (@a&0x80)>>7
    end
    # increment (memory)
    def inc(arg, mode)
      r = (@mem.get(arg) + 1)&0xff
      @mem.set( arg, r )
      @z = r.zero? ? 1 : 0
      @n = (r&0x80)>>7
    end
    # increment (x)
    def inx(arg, mode)
      r = (@x + 1)&0xff
      @x = r
      @z = r.zero? ? 1 : 0
      @n = (r&0x80)>>7
    end
    # increment (y)
    def iny(arg, mode)
      r = (@y + 1)&0xff
      @y = r
      @z = r.zero? ? 1 : 0
      @n = (r&0x80)>>7
    end
    # shift right
    def lsr(arg, mode)
      case mode
      when :acc
        @c = 0x01&@a
        @a = @a>>1
        @z = @a.zero? ? 1 : 0
        @n = (@a&0x80)>>7 #bit 7 will always be zero, though
      else
        v = @mem.get(arg)
        @c = 0x01&v
        r = v>>1
        @z = r.zero? ? 1 : 0
        @n = (r&0x80)>>7
        @mem.set( arg, r )
      end
    end
    # inclusive or
    def ora(arg, mode)
      case mode
      when :imm
        @a = @a | arg
      else
        @a = @a | @mem.get( arg )
      end
      @z = @a.zero? ? 1 : 0
      @n = (@a&0x80)>>7
    end
    # rotate left
    def rol(arg, mode)
      case mode
      when :acc
        c = @c
        @c = (@a&0x80)>>7
        @a = 0xff & (@a<<1) | c
        @z = @a.zero? ? 1 : 0
        @n = (@a&0x80)>>7
      else
        val = @mem.get(arg)
        c = @c
        @c = (val&0x80)>>7
        r = 0xff & (val<<1) | c
        @z = r.zero? ? 1 : 0
        @n = (r&0x80)>>7
        @mem.set(arg, r)
      end
    end
    # rotate right
    def ror(arg, mode)
      case mode
      when :acc
        c = @c
        @c = @a&0x01
        @a = (@a>>1) | (c<<7)
        @z = @a.zero? ? 1 : 0
        @n = (@a&0x80)>>7
      else
        val = @mem.get(arg)
        c = @c
        @c = val&0x01
        r = (val>>1) | (c<<7)
        @mem.set(arg, r)
        @z = r.zero? ? 1 : 0
        @n = (r&0x80)>>7
      end
    end
    # no operation
    def nop(arg, mode)
      @pc += 1
    end
    def sec(arg, mode)
      @c = 1
    end
    def sed(arg, mode)
      @d = 1
    end
    def sei(arg, mode)
      @i = 1
    end
    def bcc(arg, mode)
      inc_pc_by_mode(:rel)
      @pc += arg if @c == 0
    end
    def bcs(arg, mode)
      inc_pc_by_mode(:rel)
      @pc += arg if @c == 1
    end
    def beq(arg, mode)
      inc_pc_by_mode(:rel)
      @pc += arg if @z == 1
    end
    def bmi(arg, mode)
      inc_pc_by_mode(:rel)
      @pc += arg if @n == 1
    end
    def bne(arg, mode)
      inc_pc_by_mode(:rel)
      @pc += arg if @z == 1
    end
    def bpl(arg, mode)
      inc_pc_by_mode(:rel)
      @pc += arg if @n == 0
    end
    def bvc(arg, mode)
      inc_pc_by_mode(:rel)
      @pc += arg if @v == 0
    end
    def bvs(arg, mode)
      inc_pc_by_mode(:rel)
      @pc += arg if @v == 1
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
      @v = 0
    end
    def cmp(arg, mode)
      case mode
      when :imm
        result = @a - arg
        @c = result >= 0 ? 1 : 0
        @z = result == 0 ? 1 : 0
        @n = (0xff&result)>>7
      else
        m = @mem.get( arg )
        result = @a - m
        @c = result >= 0 ? 1 : 0
        @z = result == 0 ? 1 : 0
        @n = (0xff&result)>>7
      end
    end
    def cpx(arg, mode)
      case mode
      when :imm
        result = @x - arg
        @c = result >= 0 ? 1 : 0
        @z = result == 0 ? 1 : 0
        @n = (0xff&result)>>7
      else
        m = @mem.get( arg )
        result = @x - m
        @c = result >= 0 ? 1 : 0
        @z = result == 0 ? 1 : 0
        @n = (0xff&result)>>7
      end
    end
    def cpy(arg, mode)
      case mode
      when :imm
        result = @y - arg
        @c = result >= 0 ? 1 : 0
        @z = result == 0 ? 1 : 0
        @n = (0xff&result)>>7
      else
        m = @mem.get( arg )
        result = @y - m
        @c = result >= 0 ? 1 : 0
        @z = result == 0 ? 1 : 0
        @n = (0xff&result)>>7
      end
    end
    def jmp(arg, mode)
      case mode
      when :abs
        @pc = arg
      else #indirect
        lsb = @mem.get( arg )
        msb = @mem.get( arg + 1)
        @pc = lsb + msb<<8
      end
    end
    def lda(arg, mode)
      case mode
      when :imm
        @a = arg
      else
        @a = @mem.get( arg )
      end
      @z = @a.zero? ? 1 : 0
      @n = (0x80&@a)>>7
    end
    def ldx(arg, mode)
      case mode
      when :imm
        @x = arg
      else
        @x = @mem.get( arg )
      end
      @z = @x.zero? ? 1 : 0
      @n = (0x80&@x)>>7
    end
    def ldy(arg, mode)
      case mode
      when :imm
        @y = arg
      else
        @y = @mem.get( arg )
      end
      @z = @y.zero? ? 1 : 0
      @n = (0x80&@y)>>7
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
      @z = @a.zero? ? 1 : 0
      @n = (0x80&@a)>>7
    end
    def php()
      addr = 0x0100 + (0xff & @s)
      val =            @n #bit 7
      val = (val<<1) + @v #bit 6
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
      @v = 0x1 & (val>>6)
      @n = 0x1 & (val>>7)
    end
    def sta(arg, mode)
      @mem.set( arg, @a )
    end
    def stx(arg, mode)
      @mem.set( arg, @x )
    end
    def sty(arg, mode)
      @mem.set( arg, @y )
    end
    def tax()
      @x = @a
      @z = @x.zero? ? 1 : 0
      @n = (0x80&@x)>>7
    end
    def tay()
      @y = @a
      @z = @y.zero? ? 1 : 0
      @n = (0x80&@y)>>7
    end
    def tsx()
      @x = @s
      @z = @x.zero? ? 1 : 0
      @n = (0x80&@x)>>7
    end
    def txa()
      @a = @x
      @z = @a.zero? ? 1 : 0
      @n = (0x80&@a)>>7
    end
    def txs()
      @s = @x
    end
    def tya()
      @a = @y
      @z = @a.zero? ? 1 : 0
      @n = (0x80&@a)>>7
    end
    def brk()
      @mem.set(0x0100 + @s, @pc>>8)
      @s -= 1
      @mem.set(0x0100 + @s, (0xff&@pc))
      @s -= 1
      val =            @n #bit 7
      val = (val<<1) + @v #bit 6
      val = (val<<1) +  1 #bit 5
      val = (val<<1) +  1 #bit 4 break flag
      val = (val<<1) + @d #bit 3
      val = (val<<1) + @i #bit 2
      val = (val<<1) + @z #bit 1
      val = (val<<1) + @c #bit 0
      @mem.set(0x0100 + @s, val)
      @s -= 1

      lo = @mem.get(0xfffe)
      hi = @mem.get(0xffff)
      @pc = (hi<<8) + lo
    end
    def rti
      flags = @mem.get(0x0100 + @s + 1)
      @s += 1

      @c = 0x1 & flags
      @z = 0x1 & (flags>>1)
      @i = 0x1 & (flags>>2)
      @d = 0x1 & (flags>>3)
      @b = 0x1 & (flags>>4)
      # bit 5
      @v = 0x1 & (flags>>6)
      @n = 0x1 & (flags>>7)

      hi = @mem.get(0x0100 + @s + 1)
      @s += 1
      lo = @mem.get(0x0100 + @s + 1)
      @s += 1
      @pc = 0xffff&((hi<<8) + lo)
    end
    def jsr( arg, mode )
      @mem.set(0x0100 + @s, @pc>>8)
      @s -= 1
      @mem.set(0x0100 + @s, (0xff&@pc) + 2)
      @s -= 1
      @pc = arg
    end
    def rts
      hi = @mem.get(0x0100 + @s + 1)
      @s += 1
      lo = @mem.get(0x0100 + @s + 1)
      @s += 1
      @pc = 0xffff&((hi<<8) + lo + 1)
    end
  end
end
