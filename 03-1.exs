defmodule AdventOfCode do
  def compartments(items) do
    len2 = items |> byte_size |> div(2)
    <<fst::binary-size(len2), snd::binary-size(len2)>> = items
    {fst, snd}
  end

  def priority_items({l, r}) do
    l = l |> to_charlist() |> MapSet.new()
    r = r |> to_charlist() |> MapSet.new()
    MapSet.intersection(l, r) |> Enum.to_list() |> hd()
  end

  def priority(i) when i in ?a..?z, do: i - ?a + 1
  def priority(i) when i in ?A..?Z, do: i - ?A + 27

  def rucksack do
    {:ok, body} = File.read("./input.txt")

    body
    |> String.split("\n")
    |> Enum.map(&compartments/1)
    |> Enum.map(&priority_items/1)
    # |> Enum.map(&priority/1)
    # |> Enum.sum()
    |> IO.inspect()
  end
end

AdventOfCode.rucksack()
