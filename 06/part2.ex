data = File.read!("input.txt")
|> String.split("\n", trim: true)
|> Enum.map(&String.trim/1)

result = data
|> Enum.chunk_while( # Chunk data on empty lines
  [],
  fn item, acc ->
    if item == "" do
      {:cont, Enum.reverse(acc), []}
    else
      {:cont, [item | acc]}
    end
  end,
  fn
    [] -> {:cont, []}
    acc -> {:cont, acc, []}
  end
)
|> Enum.reject(fn item -> item == [""] end)
|> Enum.map(fn answers ->
  group_size = Enum.count answers

  Enum.join(answers)
  |> String.codepoints
  |> Enum.frequencies
  |> Enum.filter(fn {_, v} -> v == group_size end)
  |> Enum.count
end)
|> Enum.sum

IO.inspect result
