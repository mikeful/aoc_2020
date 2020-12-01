data = File.read!("part1.txt")
|> String.split("\n", trim: true)
|> Enum.map(&String.trim/1)
|> Enum.map(&String.to_integer/1)

pairs = for x <- data, y <- data, z <- data, uniq: true, do: if(x + y + z == 2020, do: [x, y, z])

result = Enum.filter(pairs, & !is_nil(&1))
|> List.first
|> Enum.reduce(1, fn item, acc -> acc * item end)

IO.inspect(result)
