defmodule Computer do
  def step memory do
    instruction = Enum.at(memory.program, memory.pointer)

    if instruction == nil do
      throw {:finish, memory}
    end

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

# Collected indexes of jmp/nop instructions
jmp_indexes = Enum.with_index(data)
|> Enum.map(fn {item, index} -> if(item["operation"] == "jmp", do: index) end)
|> Enum.reject(&is_nil/1)

nop_indexes = Enum.with_index(data)
|> Enum.map(fn {item, index} -> if(item["operation"] == "nop", do: index) end)
|> Enum.reject(&is_nil/1)

# Brute force swap both instruction indexes in program and run until infinite loop or finish
jmp_indexes |> Enum.each(fn replace_index ->
  try do
      # Replace operation of instruction
      new_instruction = Enum.at(data, replace_index) |> put_in(["operation"], "nop")
      modified_data = List.replace_at data, replace_index, new_instruction

      memory = %{program: modified_data, pointer: 0, acc: 0}
      program_visited = MapSet.new

      0..(program_length * 2) # Good enough
      |> Enum.reduce({memory, program_visited}, fn _, {memory, program_visited} ->
        new_memory = Computer.step memory

        # Check if we have looped the program
        if MapSet.member? program_visited, new_memory.pointer do
          # Stop processing
          throw {:loop, memory}
        end

        # Add pointer to visited locations
        program_visited = MapSet.put program_visited, new_memory.pointer

        {new_memory, program_visited}
      end)
  catch
    {:finish, memory} -> IO.inspect memory, label: "Program finished"
    {:loop, _} -> nil
  end
end)

nop_indexes |> Enum.each(fn replace_index ->
  try do
      # Replace operation of instruction
      new_instruction = Enum.at(data, replace_index) |> put_in(["operation"], "jmp")
      modified_data = List.replace_at data, replace_index, new_instruction

      memory = %{program: modified_data, pointer: 0, acc: 0}
      program_visited = MapSet.new

      0..(program_length * 2) # Good enough
      |> Enum.reduce({memory, program_visited}, fn _, {memory, program_visited} ->
        new_memory = Computer.step memory

        # Check if we have looped the program
        if MapSet.member? program_visited, new_memory.pointer do
          # Stop processing
          throw {:loop, memory}
        end

        # Add pointer to visited locations
        program_visited = MapSet.put program_visited, new_memory.pointer

        {new_memory, program_visited}
      end)
  catch
    {:finish, memory} -> IO.inspect memory, label: "Program finished"
    {:loop, _} -> nil
  end
end)
