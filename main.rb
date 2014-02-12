require_relative 'virtual_machine'

challenge_array = []
challenge_file = File.new('challenge.bin', 'rb')

while !(challenge_file.eof?)
  challenge_array.push(challenge_file.read(2).unpack('S<')[0])
end

vm = VirtualMachine.new
vm.load_program(challenge_array)
vm.run
