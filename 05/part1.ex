data = File.read!("input.txt")
|> String.split("\n", trim: true)
|> Enum.map(&String.trim/1)

result = data
|> Enum.map(fn ticket ->
  splits = String.codepoints(ticket)

  rows = for x <- 0..127, do: x
  row = Enum.slice(splits, 0..6) |> Enum.reduce(rows, fn split, acc ->
    max = (Enum.count acc) - 1
    half = round(max / 2)

    case split do
      "B" -> Enum.slice acc, half..max
      "F" -> Enum.slice acc, 0..(half - 1)
    end
  end) |> List.first

  columns = for x <- 0..8, do: x
  column = Enum.slice(splits, -3..-1) |> Enum.reduce(columns, fn split, acc ->
    max = (Enum.count acc) - 1
    half = round(max / 2)

    case split do
      "R" -> Enum.slice acc, half..max
      "L" -> Enum.slice acc, 0..(half - 1)
    end
  end) |> List.first

  row * 8 + column
end)
|> Enum.max

IO.inspect result
