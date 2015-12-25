class OpCodeInterpreter
	def initialize
		@op_codes =
				{0 => {args: 0, op_name: 'halt', name: 'Halt'},
				 1 => {args: 2, op_name: 'set',  name: 'Set'},
				 2 => {args: 1, op_name: 'push', name: 'Push'},
				 3 => {args: 1, op_name: 'pop',  name: 'Pop'},
				 4 => {args: 3, op_name: 'eq',   name: 'Equals'},
				 5 => {args: 3, op_name: 'gt',   name: 'Greater Than'},
				 6 => {args: 1, op_name: 'jmp',  name: 'Jump'},
				 7 => {args: 2, op_name: 'jt',   name: 'Jump If Not Zero'},
				 8 => {args: 2, op_name: 'jf',   name: 'Jump If Zero'},
				 9 => {args: 3, op_name: 'add',  name: 'Add'},
				 10 => {args: 3, op_name: 'mult', name: 'Multiply'},
				 11 => {args: 3, op_name: 'mod',  name: 'Modulo'},
				 12 => {args: 3, op_name: 'and',  name: 'And'},
				 13 => {args: 3, op_name: 'or',   name: 'Or'},
				 14 => {args: 2, op_name: 'not',  name: 'Not'},
				 15 => {args: 2, op_name: 'rmem', name: 'Read Memory'},
				 16 => {args: 2, op_name: 'wmem', name: 'Write Memory'},
				 17 => {args: 1, op_name: 'call', name: 'Call'},
				 18 => {args: 0, op_name: 'ret',  name: 'Return'},
				 19 => {args: 1, op_name: 'out',  name: 'Output'},
				 20 => {args: 1, op_name: 'in',   name: 'Input'},
				 21 => {args: 0, op_name: 'nop',  name: 'No Operation'}}
	end

	def num_args(op)
		code = @op_codes[op]
		return 0 if code.nil?
		code[:args]
	end

	def name(op)
		code = @op_codes[op]
		return '' if code.nil?
		code[:name]
	end

	def op_name(op)
		code = @op_codes[op]
		return '' if code.nil?
		code[:op_name]
	end
end