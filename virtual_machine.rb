require 'byebug'
require 'highline/system_extensions'
require_relative 'op_code_interpreter'
include HighLine::SystemExtensions

class VirtualMachine
  def initialize
    @stack = []
    @registers = [0] * 8
    @instructions = []
    @running = true
    @pc = 0
    @op_code = OpCodeInterpreter.new
    $stdout.sync = true
  end

  def halt
    @running = false
  end

  def run
    @running = true
    while @running do
      next_instruction = @instructions[@pc]
      num_args = @op_code.num_args(next_instruction)
      args = []
      if num_args > 0
        args = @instructions[(@pc+1)..(@pc+num_args)]
      end
      @pc += 1 + num_args
      run_op next_instruction, args
    end
  end

  def run_op(instruction, args)
    case instruction
    when 0
      @running = false

    when 1
      set_register(args[0], process_arg(args[1]))

    when 2
      @stack.push(process_arg(args[0]))

    when 3
      popped = @stack.pop
      unless popped.nil?
        set_register(args[0], popped)
      else
        puts "Error! Stack was empty during pop!"
      end

    when 4
      if process_arg(args[1]) == process_arg(args[2])
        set_register(args[0], 1)
      else
        set_register(args[0], 0)
      end

    when 5
      if process_arg(args[1]) > process_arg(args[2])
        set_register(args[0], 1)
      else
        set_register(args[0], 0)
      end

    when 6
      @pc = process_arg(args[0])

    when 7
      if process_arg(args[0]) != 0
        location = process_arg(args[1])
        @pc = location
      end

    when 8
      if process_arg(args[0]) == 0
        location = process_arg(args[1])
        @pc = location
      end

    when 9
      sum = (process_arg(args[1]) + process_arg(args[2])) % 32768
      set_register(args[0], sum)

    when 10
      sum = (process_arg(args[1]) * process_arg(args[2])) % 32768
      set_register(args[0], sum)

    when 11
      sum = (process_arg(args[1]) % process_arg(args[2]))
      set_register(args[0], sum)

    when 12
      sum = (process_arg(args[1]) & process_arg(args[2]))
      set_register(args[0], sum)

    when 13
      sum = (process_arg(args[1]) | process_arg(args[2]))
      set_register(args[0], sum)

    when 14
      set_register(args[0], 32767 - process_arg(args[1]))

    when 15
      memory = @instructions[process_arg(args[1])]
      set_register(args[0], memory)

    when 16
      @instructions[process_arg(args[0])] = process_arg(args[1])

    when 17
      @stack.push @pc
      @pc = process_arg(args[0])

    when 18
      value = @stack.pop
      if value.nil?
        @running = false
      else
        @pc = value
      end

    when 19
      print process_arg(args[0]).chr

    when 20
      char = get_character
      if char == 37
        byebug
      end
      set_register(args[0], char)

    when 21

    else
      puts "Unknown instruction! OpCode: #{instruction}, Instruction: #{@op_code.name(instruction)}, Args: #{args}"
      @running = false
    end
  end

  def process_arg(arg)
    if arg.between? 0, 32767
      arg
    elsif arg.between? 32768, 32775
      @registers[arg - 32768]
    else
      puts 'Invalid value!'
    end
  end

  def set_register(register, value)
    @registers[register - 32768] = value
  end

  def load_program(program)
    @instructions = program
  end
end
