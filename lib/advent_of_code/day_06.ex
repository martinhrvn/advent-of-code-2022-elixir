defmodule AdventOfCode.Day06 do
  def part1(input) do
    input
    |> find_first_distsinct(4)
  end

  def part2(input) do
    input
    |> find_first_distsinct(14)
  end

  defp find_first_distsinct(input, n) do
    input
    |> String.to_charlist()
    |> Enum.reduce_while({'', 1}, fn char, {acc, count} ->
      chars = [char | Enum.take(acc, n - 1)]

      if length(Enum.uniq(chars)) == n do
        {:halt, count}
      else
        {:cont, {chars, count + 1}}
      end
    end)
  end
end
