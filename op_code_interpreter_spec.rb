require_relative "op_code_interpreter.rb"

describe "Opcode Interpreter" do
  before(:each) do
    @op_int = OpCodeInterpreter.new
  end

  it "returns nil if the opcode isn't real" do
     @op_int.parse(30).should be_nil
  end

  describe "Number of Arguments" do
    it "raises an exception for unknown op codes" do
      expect {
        @op_int.number_of_args(100)
      }.to raise_exception
    end

    it "returns the correct number of arguments" do
      @op_int.number_of_args(19).should == 1
    end
  end
end
