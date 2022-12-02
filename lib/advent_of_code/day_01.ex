defmodule AdventOfCode.Day01 do
  def part1(lines) do
    lines |> top_calories |> hd
  end

  def part2(lines) do
    lines |> top_calories |> Enum.take(3) |> Enum.sum()
  end

  defp top_calories(lines) do
    lines
    |> String.split("\n")
    |> Enum.chunk_by(fn l -> l == "" end)
    |> Enum.map(fn arr ->
      arr
      |> Enum.filter(fn n -> n != "" end)
      |> Enum.map(&String.to_integer/1)
      |> Enum.sum()
    end)
    |> Enum.sort(:desc)
  end
end
