defmodule AdventOfCode.Day09 do
  def part1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [direction, count] = line |> String.split(" ", trim: true)
      {direction, String.to_integer(count)}
    end)
    |> Enum.flat_map(fn {d, c} -> List.duplicate(d, c) end)
    |> IO.inspect(label: "input")
    |> Enum.reduce({%{}, {0, 0}, {0, 0}}, fn d, {visited, head, tail} ->
      move(visited, head, tail, d)
    end)
    |> then(fn {visited, _, _} -> visited |> map_size() end)
  end

  def part2(_args) do
  end

  defp dir("R"), do: {0, 1}
  defp dir("L"), do: {0, -1}
  defp dir("U"), do: {-1, 0}
  defp dir("D"), do: {1, 0}

  defp move(visited, {hx, hy}, {tx, ty}, d) do
    {dx, dy} = dir(d)
    head = {hx + dx, hy + dy}

    new_tail = calculate_tail(head, {tx, ty})
    visited = Map.put(visited, new_tail, [])
    {visited, head, new_tail}
  end

  defp calculate_tail({hx, hy}, {tx, ty}) do
    dx = hx - tx
    dy = hy - ty

    cond do
      abs(dx) < 2 and abs(dy) < 2 -> {tx, ty}
      abs(dx) < 2 -> {hx, hy - sign(dy)}
      abs(dy) < 2 -> {hx - sign(dx), hy}
      true -> {hx - sign(dx), hy - sign(dy)}
    end
  end

  defp sign(0), do: 0
  defp sign(n) when n > 0, do: 1
  defp sign(_), do: -1
end
