defmodule AdventOfCode.Day10 do
  def part1(input) do
    input
    |> get_cycles()
    |> Enum.with_index()
    |> Enum.drop(19)
    |> Enum.take_every(40)
    |> Enum.map(fn {x, cycle} -> x * (cycle + 1) end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> get_cycles()
    |> Enum.chunk_every(40)
    |> Enum.map(fn chunk ->
      chunk
      |> Enum.with_index()
      |> Enum.map(fn
        {acc_x, idx} when abs(acc_x - idx) < 2 -> 'X'
        _ -> '.'
      end)
      |> Enum.join()
    end)
    |> Enum.join("\n")
    |> IO.puts()
  end

  defp get_cycles(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce({[], 1}, fn
      "addx " <> num, {nums, acc_x} ->
        {[acc_x, acc_x | nums], acc_x + String.to_integer(num)}

      "noop", {nums, acc_x} ->
        {[acc_x | nums], acc_x}
    end)
    |> elem(0)
    |> Enum.reverse()
  end
end
