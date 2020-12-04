data = File.read!("input.txt")
|> String.split("\n", trim: true)
|> Enum.map(&String.trim/1)

all_tags = MapSet.new ["byr", "iyr", "eyr", "hgt", "hcl", "pid", "ecl", "cid"]
cid_tags = MapSet.new ["cid"]
empty_tags = MapSet.new

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
|> Enum.filter(fn rows ->
  # Extract passport field names
  tags = Enum.map(rows, fn row ->
    Regex.scan(~r/(?<field>\w{3}):/, row, capture: ["field"])
  end)
  |> List.flatten
  |> MapSet.new

  # Check for valid field set
  if MapSet.difference(all_tags, tags) in [cid_tags, empty_tags] do
    true
  else
    false
  end
end)
|> Enum.count

IO.inspect(result)
