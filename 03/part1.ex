data = File.read!("input.txt")
|> String.split("\n", trim: true)
|> Enum.map(&String.trim/1)

line_length = (List.first(data) |> String.length)

result = Enum.with_index(data)
|> Enum.map(fn {line, y} ->
  if y == 0 do
    0
  else
    tiles = String.codepoints(line)
    position = y * 3
    line_position = Integer.mod(position, line_length)

    if(Enum.at(tiles, line_position) == "#", do: 1, else: 0)
  end
end)
|> Enum.sum

IO.inspect(result)
