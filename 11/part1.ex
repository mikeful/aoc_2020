defmodule SeatSimulator do
  def step seats, last_changes do
    if last_changes != 0 do
      # Simulate all seats
      rows = (seats |> Enum.count) - 1
      columns = (seats[0] |> Enum.count) - 1
      coordinates = for row <- 0..rows, column <- 0..columns, do: [row, column]

      {new_seats, changes} = coordinates
      |> Enum.reduce({seats, 0}, fn [seat_row, seat_column], {updated_seats, changes} ->
        # Setup coordinate list for surrounding seats
        row_range = max(0, seat_row - 1)..min(seat_row + 1, rows)
        column_range = max(0, seat_column - 1)..min(seat_column + 1, columns)

        seat_coordinates = (for row <- row_range, column <- column_range, do: [row, column])
        |> Enum.reject(fn [row, column] -> row == seat_row and column == seat_column end)

        seat = seats[seat_row][seat_column]

        occupied_surrounding = seat_coordinates
        |> Enum.map(fn [surround_row, surround_column] ->
          case seats[surround_row][surround_column] do
            "#" -> 1 # occupied seat
            "L" -> 0 # free seat
            "." -> 0 # floor
          end
        end)
        |> Enum.sum

        case {seat, occupied_surrounding} do
          {"L", 0} -> {put_in(updated_seats[seat_row][seat_column], "#"), changes + 1}
          {"#", count} when count >= 4 -> {put_in(updated_seats[seat_row][seat_column], "L"), changes + 1}
          _ -> {updated_seats, changes}
        end
      end)

      # Loop
      SeatSimulator.step new_seats, changes
    else
      # End loop
      seats
    end
  end
end

data = File.read!("input.txt")
|> String.split("\n", trim: true)
|> Enum.map(&String.trim/1)
|> Enum.map(&String.codepoints/1)

# Form nested lists into map for nicer access: map[0][0]
seats = Enum.with_index(data)
|> Map.new(fn {row, index} ->
  {index, Enum.with_index(row) |> Map.new(fn {column, index} -> {index, column} end)}
end)

result = SeatSimulator.step(seats, 1)
|> Map.to_list
|> Enum.map(fn {_index, row} -> Map.to_list(row) |> Enum.map(fn {_index, column} -> column end) end)
|> List.flatten
|> Enum.frequencies

IO.inspect result
