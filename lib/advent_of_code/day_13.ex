defmodule AdventOfCode.Day13 do
  @div1 [[2]]
  @div2 [[6]]
  def part1(input) do
    get_signals(input)
    |> Enum.with_index(1)
    |> Enum.filter(fn {[a, b], _idx} -> compare(a, b) != :gt end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  def part2(input) do
    get_signals(input)
    |> Enum.concat([[@div1], [@div2]])
    |> Enum.concat()
    |> Enum.sort(fn a, b -> compare(a, b) == :lt end)
    |> Enum.with_index(1)
    |> Enum.filter(fn {packet, _idx} -> packet in [@div1, @div2] end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.product()
  end

  defp get_signals(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn lines ->
      String.split(lines, "\n", trim: true) |> Enum.map(&Code.string_to_quoted!/1)
    end)
  end

  defp compare(a, a), do: :eq
  defp compare(a, b) when is_integer(a) and is_integer(b) and a < b, do: :lt
  defp compare([], [_ | _]), do: :lt
  defp compare([a | as], [b | bs]), do: with(:eq <- compare(a, b), do: compare(as, bs))

  defp compare(a, b)
       when is_integer(a) and is_list(b)
       when is_list(a) and is_integer(b),
       do: compare(List.wrap(a), List.wrap(b))

  defp compare(_, _), do: :gt
end
