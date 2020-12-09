data = File.read!("input.txt")
|> String.split("\n", trim: true)
|> Enum.map(&String.trim/1)
|> Enum.map(&String.to_integer/1)

preamble_len = 25

try do
  Enum.with_index(data)
  |> Enum.reduce(data, fn {item, index}, acc ->
    if index >= preamble_len do
      check_list = Enum.slice acc, (index - preamble_len)..(index - 1)
      check_combinations = for x <- check_list, y <- check_list, x != y, into: MapSet.new, do: x + y

      if !(MapSet.member? check_combinations, item) do
        throw {:ok, item}
      end
    end

    acc
  end)
catch
  {:ok, value} -> IO.inspect value, label: "Match not found for"
  item -> IO.inspect item
end
