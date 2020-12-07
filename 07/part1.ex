defmodule TreeScanner do
  def scan {parent, list}, level, content_map do
    case {parent, list, level} do
      {"shiny gold", _, level} when level > 0 -> 1
      {_, [], _} -> 0
      {_, list, _} -> Enum.map(list, fn item -> scan({item, Map.get(content_map, item)}, level + 1, content_map) end)
      |> Enum.sum
    end
  end
end

data = File.read!("input.txt")
|> String.split("\n", trim: true)
|> Enum.map(&String.trim/1)

content_map = data
|> Enum.map(&String.split(&1, " bags contain "))
|> Enum.reduce(%{}, fn [container, contents], acc ->
  # Build container content map
  content_list = Regex.scan(~r/\d+ (.+) bags?/U, contents)
  |> Enum.map(fn
    [_, content] -> content
  end)

  Map.put(acc, container, content_list)
end)

result = Enum.map(content_map, &TreeScanner.scan(&1, 0, content_map))
|> Enum.reject(fn x -> x == 0 end)
|> Enum.count

IO.inspect result
