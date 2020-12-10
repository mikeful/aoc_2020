data = File.read!("input.txt")
|> String.split("\n", trim: true)
|> Enum.map(&String.trim/1)
|> Enum.map(&String.to_integer/1)
|> Enum.sort

result = data
|> Enum.reduce(%{last: 0, jolt1: 0, jolt3: 0}, fn adapter, acc ->
  case adapter - acc.last do
    1 -> %{last: adapter, jolt1: acc.jolt1 + 1, jolt3: acc.jolt3}
    3 -> %{last: adapter, jolt1: acc.jolt1, jolt3: acc.jolt3 + 1}
  end
end)
|> update_in([:jolt3], &(&1 + 1))
|> (fn result -> result.jolt1 * result.jolt3 end).()

IO.inspect result
