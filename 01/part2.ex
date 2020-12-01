data = File.read!("part1.txt")
|> String.split("\n", trim: true)
|> Enum.map(&String.trim/1)
|> Enum.map(&String.to_integer/1)

pairs = for x <- data, y <- data, z <- data, uniq: true, do: MapSet.new([x, y, z])

correct_pair = Enum.filter(pairs, fn item -> Enum.sum(item) == 2020 end)
|> List.first

result = Enum.reduce(MapSet.to_list(correct_pair), 1, fn item, acc -> acc * item end)

IO.inspect(result)
