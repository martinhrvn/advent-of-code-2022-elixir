defmodule AdventOfCode.Day09 do
  def part1(input) do
    simulate(input, 2)
  end

  def part2(input) do
    simulate(input, 10)
  end

  defp simulate(input, segments) do
    rope = List.duplicate({0, 0}, segments)

    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [direction, count] = line |> String.split(" ", trim: true)
      {direction, String.to_integer(count)}
    end)
    |> Enum.flat_map(fn {d, c} -> List.duplicate(d, c) end)
    |> Enum.reduce({rope, MapSet.new([List.last(rope)])}, fn direction, {rope, visited} ->
      new_rope = move(rope, direction)
      {new_rope, MapSet.put(visited, List.last(new_rope))}
    end)
    |> then(fn {_, visited} -> visited |> MapSet.size() end)
  end

  defp dir("R"), do: {0, 1}
  defp dir("L"), do: {0, -1}
  defp dir("U"), do: {-1, 0}
  defp dir("D"), do: {1, 0}

  defp move([{x, y} | rest], d) do
    {dx, dy} = dir(d)
    head = {x + dx, y + dy}

    move_tails([head | rest])
  end

  defp move_tails([head]), do: [head]

  defp move_tails([{hx, hy}, {tx, ty} | _] = rope) when abs(hx - tx) < 2 and abs(hy - ty) < 2,
    do: rope

  defp move_tails([{hx, hy}, {tx, ty} | rest]) when abs(hx - tx) < 2 do
    [{hx, hy} | move_tails([{hx, hy - sign(hy - ty)} | rest])]
  end

  defp move_tails([{hx, hy}, {tx, ty} | rest]) when abs(hy - ty) < 2 do
    [{hx, hy} | move_tails([{hx - sign(hx - tx), hy} | rest])]
  end

  defp move_tails([{hx, hy}, {tx, ty} | rest]) do
    [{hx, hy} | move_tails([{hx - sign(hx - tx), hy - sign(hy - ty)} | rest])]
  end

  defp sign(0), do: 0
  defp sign(n) when n > 0, do: 1
  defp sign(_), do: -1
end
