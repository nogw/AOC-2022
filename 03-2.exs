defmodule AdventOfCode do
  def priority(i) when i in ?a..?z, do: i - ?a + 1
  def priority(i) when i in ?A..?Z, do: i - ?A + 27

  def rucksack do
    {:ok, body} = File.read("./input.txt")

    body
    |> String.split("\n")
    |> Enum.map(&to_charlist/1)
    |> Enum.map(&MapSet.new/1)
    |> Enum.chunk_every(3)
    |> Enum.map(fn lst -> Enum.reduce(lst, &MapSet.intersection/2) end)
    |> Enum.map(&Enum.to_list/1)
    |> Enum.map(&hd/1)
    |> Enum.map(&priority/1)
    |> Enum.sum()
    |> IO.inspect()
  end
end

AdventOfCode.rucksack()
