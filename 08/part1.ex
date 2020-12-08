defmodule Computer do
  def step memory do
    instruction = Enum.at(memory.program, memory.pointer)

    operation = Map.get(instruction, "operation")
    value = Map.get(instruction, "value") |> String.to_integer

    case operation do
      "nop" -> put_in(memory, [:pointer], memory.pointer + 1)
      "acc" -> put_in(memory, [:acc], memory.acc + value) |> put_in([:pointer], memory.pointer + 1)
      "jmp" -> put_in(memory, [:pointer], memory.pointer + value)
    end
  end
end

data = File.read!("input.txt")
|> String.split("\n", trim: true)
|> Enum.map(&String.trim/1)
|> Enum.map(fn row ->
  Regex.named_captures(~r/(?<operation>\w{3}) (?<value>(\+|-)\d+)/, row)
end)

program_length = Enum.count data
memory = %{program: data, pointer: 0, acc: 0}
program_visited = MapSet.new

try do
  0..(program_length * 2) # Good enough
  |> Enum.reduce({memory, program_visited}, fn _, {memory, program_visited} ->
    new_memory = Computer.step memory

    # Check if we have looped the program
    if MapSet.member? program_visited, new_memory.pointer do
      # Stop processing
      throw memory
    end

    # Add pointer to visited locations
    program_visited = MapSet.put program_visited, new_memory.pointer

    {new_memory, program_visited}
  end)
catch value ->
  IO.inspect value, label: "Infinite loop detected"
end
