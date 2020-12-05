data = File.read!("input.txt")
|> String.split("\n", trim: true)
|> Enum.map(&String.trim/1)

ticket_seats = data
|> Enum.map(fn ticket ->
  splits = String.codepoints(ticket)
  rows = for x <- 0..127, do: x
  columns = for x <- 0..8, do: x

  row = Enum.slice(splits, 0..6)
  |> Enum.reduce(rows, fn split, acc ->
    max = (Enum.count acc) - 1
    half = round(max / 2)

    case split do
      "B" -> Enum.slice acc, half..max
      "F" -> Enum.slice acc, 0..(half - 1)
    end
  end)
  |> List.first

  column = Enum.slice(splits, -3..-1)
  |> Enum.reduce(columns, fn split, acc ->
    max = (Enum.count acc) - 1
    half = round(max / 2)

    case split do
      "R" -> Enum.slice acc, half..max
      "L" -> Enum.slice acc, 0..(half - 1)
    end
  end)
  |> List.first

  [row, column]
end)

min_row = ticket_seats |> Enum.map(fn [row, _] -> row end) |> Enum.min
max_row = ticket_seats |> Enum.map(fn [row, _] -> row end) |> Enum.max

all_seat_ids = for row <- min_row..max_row, column <- 0..7, do: row * 8 + column
ticket_seat_ids = ticket_seats |> Enum.map(fn [row, column] -> row * 8 + column end)

result = MapSet.difference(MapSet.new(all_seat_ids), MapSet.new(ticket_seat_ids))

IO.inspect result
