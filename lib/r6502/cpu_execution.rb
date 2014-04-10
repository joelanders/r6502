module R6502
  class Cpu
    attr_accessor :mem, :pc, :s, :x, :y, :a
    attr_accessor :c, :z, :i, :d, :b, :v, :n
    def initialize(mem)
      @mem = mem
      @pc = @mem.get_word(0xfffc)
      @s  = 0xff
      @x  = 0x00
      @y  = 0x00
      @a  = 0x00
      @c  = 0
      @z  = 0
      @i  = 0
      @d  = 0
      @b  = 0
      @v  = 0
      @n  = 0
    end
    def step
      instr, mode = instr_mode( mem.get(pc) )
      arg = decode_arg( mode, mem.get(pc+1), mem.get(pc+2) )

      puts "instr: #{instr} at pc 0x#{pc.to_s(16)} with arg #{arg.to_i.to_s(16)}"
      method( instr ).call( arg, mode )
      puts " a: #{a.to_s(16)} x: #{x.to_s(16)} y: #{y.to_s(16)} z: #{z.to_s(16)} n: #{n.to_s(16)} c: #{c.to_s(16)}"
      puts "==="
    end
    def decode_arg(mode, sec_word, thd_word)
      case mode
      when :imp
          nil
      when :acc
          nil
      when :imm
        sec_word
      when :zp
        sec_word
      when :zpx
        sec_word + @x
      when :zpy
        sec_word + @y
      when :rel
        sec_word <= 127 ? sec_word : sec_word - 256
      when :abs
        (thd_word<<8) + sec_word
      when :absx
        (thd_word<<8) + sec_word + @x
      when :absy
        (thd_word<<8) + sec_word + @y
      when :ind
        lb = @mem.get( (thd_word<<8) + sec_word )
        hb = @mem.get( (thd_word<<8) + sec_word + 1 )
        (hb<<8) + lb
      when :indx
        lb = @mem.get( 0xff & (@x + sec_word) )
        hb = @mem.get( 0xff & (@x + sec_word) + 1 )
        @mem.get( (hb<<8) + lb )
      when :indy
        lb = @mem.get( 0xff & sec_word )
        hb = @mem.get( 0xff & sec_word + 1)
        addr = (hb<<8) + lb
        addr + @y
      end
    end
    def inc_pc_by_mode(mode)
      case mode
      when :imp
        @pc += 1
      when :acc
        @pc += 1
      when :imm
        @pc += 2
      when :zp
        @pc += 2
      when :zpx
        @pc += 2
      when :zpy
        @pc += 2
      when :abs
        @pc += 3
      when :absx
        @pc += 3
      when :absy
        @pc += 3
      when :indx
        @pc += 2
      when :indy
        @pc += 2
      when :rel
        @pc += 2
      when :ind #only used by jmp, which explicitly sets the pc,
        @pc += 3 #so hopefully this is never used here.
      end
    end
  end
end
