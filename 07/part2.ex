defmodule TreeScanner do
  def get_count list, content_map do
    if list == [] do
      0
    else
      list
      |> Enum.map(fn item ->
        count = get_count(
          Map.get(content_map, item.bag),
          content_map
        )

        count * item.amount + item.amount
      end)
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
  content_list = Regex.scan(~r/(\d+) (.+) bags?/U, contents)
  |> Enum.map(fn
    [_, amount, content] -> %{amount: String.to_integer(amount), bag: content}
  end)

  Map.put(acc, container, content_list)
end)

gold_bag = Map.get(content_map, "shiny gold")
result = TreeScanner.get_count(gold_bag, content_map)

IO.inspect result

# too low 68935
