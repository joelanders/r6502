module R6502
  class Cpu
    # add with carry
    # DEPENDS ON DECIMAL FLAG
    # TODO
    def adc(arg, mode)
      x = @a
      y = mode == :imm ? arg : @mem.get(arg)
      r = x + y + @c
      @a = 0xff & r
      @v = (((0x7f&x) + (0x7f&y) + @c)>>7) ^ ((x + y + @c)>>8)
      @z = (r&0xff).zero? ? 1 : 0
      @c = r > 255 ? 1 : 0
      @n = (0x80&r)>>7
    end
    # subtract with carry
    # DEPENDS ON DECIMAL FLAG
    # TODO
    def sbc(arg, mode)
      x = @a
      y = mode == :imm ? arg : @mem.get(arg)
      y = (y^0xff)
      r = x + y + @c
      @a = 0xff & r
      @v = (((0x7f&x) + (0x7f&y) + @c)>>7) ^ ((x + y + @c)>>8)
      @z = (0xff&r).zero? ? 1 : 0
      @c = r > 255 ? 1 : 0
      @n = (0x80&r)>>7
    end
    # logical and
    def and(arg, mode)
      @a = @a & arg
    end
    # shift left
    def asl(arg, mode)
      case mode
      when :acc
        @a = @a<<1
      else
        @mem.set( arg, @mem.get(arg)<<1 )
      end
    end
    # logical and (result discarded)
    def bit(arg, mode)
      m = @mem.get( arg )
      a = @a
      result = a & m
      @z = 1 if result == 0
      @v = (m & 0x40)>>6
      @n = (m & 0x80)>>7
    end
    # decrement (memory)
    def dec(arg, mode)
      @mem.set( arg, @mem.get(arg) - 1 )
    end
    # decrement (x)
    def dex(arg, mode)
      @x -= 1
    end
    # decrement (y)
    def dey(arg, mode)
      @y -= 1
    end
    # exclusive or
    def eor(arg, mode)
      case mode
      when :imm
        @a = @a ^ arg
      else
        @a = @a ^ @mem.get(arg)
      end
    end
    # increment (memory)
    def inc(arg, mode)
      @mem.set( arg, @mem.get(arg) + 1 )
    end
    # increment (x)
    def inx(arg, mode)
      @x += 1
    end
    # increment (y)
    def iny(arg, mode)
      @y += 1
    end
    # shift right
    def lsr(arg, mode)
      case mode
      when :acc
        @a = @a>>1
      else
        @mem.set( arg, @mem.get(arg) >> 1 )
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
    end
    # rotate left
    def rol(arg, mode)
      case mode
      when :acc
        @a = (0xff & (@a<<1)) | ((0x80 & @a)>>7)
      else
        val = @mem.get(arg)
        val = (0xff & (val<<1)) | ((0x80 & val)>>7)
        @mem.set(arg, val)
      end
    end
    # rotate right
    def ror(arg, mode)
      #(a>>1) | ((0x01 & a)<<7)
      case mode
      when :acc
        @a = (@a>>1) | ((0x01 & @a)<<7)
      else
        val = @mem.get(arg)
        val = (val>>1) | ((0x01 & val)<<7)
        @mem.set(arg, val)
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
        #TODO negative flag
      else
        m = @mem.get( arg )
        result = @a - m
        @c = result >= 0 ? 1 : 0
        @z = result == 0 ? 1 : 0
        #TODO negative flag
      end
    end
    def cpx(arg, mode)
      case mode
      when :imm
        result = @x - arg
        @c = result >= 0 ? 1 : 0
        @z = result == 0 ? 1 : 0
        #TODO negative flag
      else
        m = @mem.get( arg )
        result = @x - m
        @c = result >= 0 ? 1 : 0
        @z = result == 0 ? 1 : 0
        #TODO negative flag
      end
    end
    def cpy(arg, mode)
      case mode
      when :imm
        result = @y - arg
        @c = result >= 0 ? 1 : 0
        @z = result == 0 ? 1 : 0
        #TODO negative flag
      else
        m = @mem.get( arg )
        result = @y - m
        @c = result >= 0 ? 1 : 0
        @z = result == 0 ? 1 : 0
        #TODO negative flag
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
    end
    def ldx(arg, mode)
      case mode
      when :imm
        @x = arg
      else
        @x = @mem.get( arg )
      end
    end
    def ldy(arg, mode)
      case mode
      when :imm
        @y = arg
      else
        @y = @mem.get( arg )
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
