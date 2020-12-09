data = File.read!("input.txt")
|> String.split("\n", trim: true)
|> Enum.map(&String.trim/1)
|> Enum.map(&String.to_integer/1)

answer = 1492208709
last_index = (Enum.count data) - 1

# Brute force all ranges and throw on correct answer
try do
  0..last_index
  |> Enum.reduce(data, fn index, acc ->
    scan_ranges = for x <- index..last_index, y <- index..last_index, x < y, do: [x, y]

    Enum.map(scan_ranges, fn [start_index, end_index] ->
      scan_items = Enum.slice(acc, start_index..end_index)
      scan_sum = Enum.sum scan_items

      if scan_sum == answer do
        throw {:ok, Enum.sort scan_items}
      end
    end)

    acc
  end)
catch
  {:ok, range} -> (List.first(range) + List.last(range)) |> IO.inspect
  item -> IO.inspect item
end
