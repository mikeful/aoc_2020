data = File.read!("input.txt")
|> String.split("\n", trim: true)
|> Enum.map(&String.trim/1)
|> Enum.map(&Regex.named_captures(~r/(?<pos1>\d+)-(?<pos2>\d+) (?<char>\w): (?<password>\w+)/, &1))

result = Enum.filter(data, fn item ->
  char = item["char"]
  pos1 = String.to_integer(item["pos1"]) - 1
  pos2 = String.to_integer(item["pos2"]) - 1
  char1 = String.at(item["password"], pos1)
  char2 = String.at(item["password"], pos2)
  if(char1 != char2 and (char1 == char or char2 == char), do: item)
end)
|> Enum.count

IO.inspect(result)
