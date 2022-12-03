defmodule AdventOfCode.Day03 do
  def part1(input) do
    input
    |> parse_input()
    |> Enum.map(fn line ->
      line
      |> then(&Enum.split(&1, div(length(&1), 2)))
      |> then(fn {a, b} -> intersect(a, b) end)
      |> hd()
      |> get_points()
    end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> parse_input()
    |> Enum.chunk_every(3)
    |> Enum.map(fn [a, b, c] -> intersect(a, b) |> intersect(c) |> hd |> get_points end)
    |> Enum.sum()
  end

  defp parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.to_charlist/1)
  end

  defp get_points(char) when char in ?a..?z, do: char - ?a + 1
  defp get_points(char) when char in ?A..?Z, do: char - ?A + 27

  @spec intersect(list, list) :: list
  defp intersect(a, b) do
    diff = a -- b
    a -- diff
  end
end
