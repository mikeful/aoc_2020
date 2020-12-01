data = File.read!("part1.txt")
|> String.split("\n", trim: true)
|> Enum.map(&String.trim/1)
|> Enum.map(&String.to_integer/1)

pairs = for x <- data, y <- data, z <- data, do: [x, y, z]

correct_pair = Enum.map(pairs, &Enum.sort/1)
|> Enum.uniq
|> Enum.filter(fn item -> Enum.sum(item) == 2020 end)
|> List.first

result = Enum.reduce(correct_pair, 1, fn item, acc -> acc * item end)

IO.inspect(result)
