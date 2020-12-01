data = File.read!("part1.txt")
|> String.split("\n", trim: true)
|> Enum.map(&String.trim/1)
|> Enum.map(&String.to_integer/1)

pairs = for x <- data, y <- data, do: [x, y]

correct_pair = Enum.map(pairs, &Enum.sort/1)
|> Enum.uniq
|> Enum.filter(fn item -> List.first(item) + List.last(item) == 2020 end)
|> List.first

result = List.first(correct_pair) * List.last(correct_pair)

IO.inspect(result)
