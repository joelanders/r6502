#!/usr/bin/env ruby
$LOAD_PATH.unshift File.expand_path('../../lib',__FILE__)
require 'r6502'
require 'pry'

@mem = R6502::Memory.new
@asm = R6502::Assembler.new(@mem)
@cpu = R6502::Cpu.new(@mem)
@cpu.pc = 0x0400

code = IO.read('6502_functional_test.bin')
raise 'too much code' if code.bytesize > 2**16

@mem.instance_variable_set( :@mem_array, code.unpack('C*') )

begin
  last_pc = @cpu.pc
  @cpu.step
end while last_pc != @cpu.pc #run it until we hit a `jmp *` loop

puts "loop at pc = 0x#{@cpu.pc.to_s(16)}"

binding.pry
