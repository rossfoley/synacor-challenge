require 'debugger'

class OpCodeInterpreter
  def initialize
  	@op_codes = {0 => {args: 0, name: 'Halt'}, 
  							 1 => {args: 2, name: 'Set'},
  							 2 => {args: 1, name: 'Push'},
  							 3 => {args: 1, name: 'Pop'},
  							 4 => {args: 3, name: 'Equals'},
  							 5 => {args: 3, name: 'Greater Than'},
  							 6 => {args: 1, name: 'Jump'},
  							 7 => {args: 2, name: 'Jump If Not Zero'},
  							 8 => {args: 2, name: 'Jump If Zero'},
  							 9 => {args: 3, name: 'Add'},
  							10 => {args: 3, name: 'Multiply'},
  							11 => {args: 3, name: 'Modulo'},
  							12 => {args: 3, name: 'And'},
  							13 => {args: 3, name: 'Or'},
  							14 => {args: 2, name: 'Not'},
  							15 => {args: 2, name: 'Read Memory'},
  							16 => {args: 2, name: 'Write Memory'},
  							17 => {args: 1, name: 'Call'},
  							18 => {args: 0, name: 'Return'},
  							19 => {args: 1, name: 'Output'},
  							20 => {args: 1, name: 'Input'},
              	21 => {args: 0, name: 'No Operation'}}
  end

  def number_of_args(op)
    code = @op_codes[op]
    return 0 if code.nil?
    code[:args]
  end

  def name_of_op(op)
  	code = @op_codes[op]
    return '' if code.nil?
    code[:name]
  end
end

class VirtualMachine
	def initialize
		@stack = []
  	@registers = [0] * 8
		@instructions = []
		@running = true
		@pc = 0
		@op_code = OpCodeInterpreter.new
	end

	def halt
		@running = false
	end

	def run
		@running = true
		while @running do
			next_instruction = @instructions[@pc]
			num_args = @op_code.number_of_args(next_instruction)
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

		when 19
			print process_arg(args[0]).chr

		when 21
			
		else
			puts "Unknown instruction! OpCode: #{instruction}, Instruction: #{@op_code.name_of_op(instruction)}, Args: #{args}"
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

$stdout.sync = true
challenge_array = []
challenge_file = File.new('challenge.bin', 'rb')

while !(challenge_file.eof?)
	challenge_array.push(challenge_file.read(2).unpack('S<')[0])
end

vm = VirtualMachine.new
vm.load_program(challenge_array)
vm.run
