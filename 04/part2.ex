data = File.read!("input.txt")
|> String.split("\n", trim: true)
|> Enum.map(&String.trim/1)

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
  fields = Enum.map(rows, fn row ->
    Regex.scan(~r/(?<field>\w{3}):(?<value>.+)(\s|$)/U, row)
  end)
  |> Enum.concat

  # Check for invalid field count
  if Enum.count(fields) < 7
  or (
    Enum.count(fields) == 7
    and Enum.filter(List.flatten(fields), fn item -> item == "cid" end) == ["cid"]
  ) do
    false
  else
    # Check field values
    valid = Enum.map(fields, fn match ->
      case match do
        [_, "byr", value, _] -> case String.to_integer(value) do
                                  value when value >= 1920 and value <= 2002 -> true
                                  _ -> false
                                end
        [_, "iyr", value, _] -> case String.to_integer(value) do
                                  value when value >= 2010 and value <= 2020 -> true
                                  _ -> false
                                end
        [_, "eyr", value, _] -> case String.to_integer(value) do
                                  value when value >= 2020 and value <= 2030 -> true
                                  _ -> false
                                end
        [_, "hgt", value, _] -> case Regex.named_captures(~r/(?<height>\d+)(?<unit>in|cm)/, value) do
                                  %{"height" => height_str, "unit" => unit} ->
                                      height = String.to_integer(height_str)
                                      case unit do
                                        "cm" when height >= 150 and height <= 193 -> true
                                        "in" when height >= 59 and height <= 76 -> true
                                        _ -> false
                                      end
                                  _ -> false
                                end
        [_, "hcl", value, _] -> value =~ ~r/^#[a-f0-9]{6}$/
        [_, "ecl", value, _] -> value =~ ~r/^(amb|blu|brn|gry|grn|hzl|oth)$/
        [_, "pid", value, _] -> value =~ ~r/^\d{9}$/
        [_, "cid", _, _] -> true
      end
    end)

    IO.inspect Enum.zip fields, valid

    Enum.all?(valid)
  end
end)
|> Enum.count

IO.inspect(result)
