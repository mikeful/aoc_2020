data = File.read!("input.txt")
|> String.split("\n", trim: true)
|> Enum.map(&String.trim/1)
|> Enum.map(&Regex.named_captures(~r/(?<min>\d+)-(?<max>\d+) (?<char>\w): (?<password>\w+)/, &1))

result = Enum.filter(data, fn item ->
  char = item["char"]
  min = String.to_integer(item["min"])
  max = String.to_integer(item["max"])
  freq = String.codepoints(item["password"]) |> Enum.frequencies
  if(freq[char] != nil and freq[char] >= min and freq[char] <= max, do: item)
end)
|> Enum.count

IO.inspect(result)
