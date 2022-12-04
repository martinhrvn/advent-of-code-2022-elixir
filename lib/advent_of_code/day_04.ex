defmodule AdventOfCode.Day04 do
  def part1(input) do
    input
    |> parse_input
    |> Enum.count(fn [{a, b}, {c, d}] -> (a <= c and d <= b) or (a >= c and b <= d) end)
  end

  def part2(input) do
    input |> parse_input() |> Enum.count(fn [{a, b}, {c, d}] -> b >= c and d >= a end)
  end

  defp parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.split(",")
      |> Enum.map(&String.split(&1, "-"))
      |> Enum.map(fn [a, b] -> {String.to_integer(a), String.to_integer(b)} end)
    end)
  end
end
