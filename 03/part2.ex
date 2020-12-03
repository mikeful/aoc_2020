data = File.read!("input.txt")
|> String.split("\n", trim: true)
|> Enum.map(&String.trim/1)

line_length = (List.first(data) |> String.length)

scan = fn [step_x, step_y] ->
  Enum.with_index(data)
  |> Enum.map(fn {line, y} ->
    if y == 0 or Integer.mod(y, step_y) != 0 do
      0
    else
      tiles = String.codepoints(line)
      position = round(y / step_y) * step_x
      line_position = Integer.mod(position, line_length)

      if(Enum.at(tiles, line_position) == "#", do: 1, else: 0)
    end
  end)
  |> Enum.sum
end

angles = [
  [1, 1],
  [3, 1],
  [5, 1],
  [7, 1],
  [1, 2]
]

result = Enum.map(angles, &scan.(&1))
|> Enum.reduce(1, fn item, acc -> acc * item end)

IO.inspect(result)
