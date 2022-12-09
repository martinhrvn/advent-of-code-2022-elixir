defmodule AdventOfCode.Day09 do
  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [direction, count] = line |> String.split(" ", trim: true)
      {direction, String.to_integer(count)}
    end)
    |> Enum.flat_map(fn {d, c} -> List.duplicate({d, c}, c) end)
    |> Enum.reduce({%{}, {0, 0}, {0, 0}}, fn {d, _}, {visited, head, tail} ->
      move(visited, head, tail, dir(d))
    end)
    |> then(fn {visited, _, _} -> map_size(visited) end)
  end

  def part2(_args) do
  end

  defp dir("R"), do: {0, 1}
  defp dir("L"), do: {0, -1}
  defp dir("U"), do: {1, 0}
  defp dir("D"), do: {-1, 0}

  defp move(visited, {hx, hy}, {tx, ty}, {dx, dy}) do
    head = {hx + dx, hy + dy}

    new_tail = calculate_tail(head, {tx, ty})
    IO.inspect(head, label: "head")
    IO.inspect(new_tail, label: "tail")
    IO.write("----------------\n")
    visited = Map.put(visited, new_tail, true)
    {visited, head, new_tail}
  end

  defp calculate_tail({hx, hy}, {tx, ty}) do
    dx = hx - tx
    dy = hy - ty

    cond do
      abs(dx) < 2 and abs(dy) < 2 -> {tx, ty}
      abs(dx) < 2 -> {hx, hy - clamp(dy)}
      abs(dy) < 2 -> {hx - clamp(dx), hy}
      true -> {hx - clamp(dx), hy - clamp(dy)}
    end
  end

  defp clamp(0), do: 0
  defp clamp(n) when n > 0, do: 1
  defp clamp(_), do: -1
end
