class OpCodeInterpreter
  @@op_codes = {0 => {args: 0, name: "Halt"}, 
              19 => {args: 1, name: "Output"},
              21 => {args: 0, name: "No Operation"}}
  def initialize
  end

  def number_of_args(op)
    code = @@op_codes[op]
    raise "Op code does not exist!" if code.nil?
    code[:args]
  end

  def parse(op, *args)
    case op
    when 0
      # Halt
    when 19
      # Output
    when 21
      # Nop
    else nil
    end
  end
end
