require_relative "op_code_interpreter.rb"

describe "Opcode Interpreter" do
  it "returns nil if the opcode isn't real" do
    op_int = OpCodeInterpreter.new
    op_int.parse(30).should be_nil
  end
end
