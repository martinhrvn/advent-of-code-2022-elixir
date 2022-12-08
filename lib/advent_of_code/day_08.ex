defmodule AdventOfCode.Day08 do
  def part1(input) do
    grid =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))

    width = Enum.at(grid, 0) |> length()
    height = grid |> length()

    grid_map =
      grid
      |> Enum.with_index()
      |> Enum.map(fn {row, y} ->
        row
        |> Enum.with_index()
        |> Enum.map(fn {pixel, x} ->
          {{x, y}, String.to_integer(pixel)}
        end)
        |> Enum.into(%{})
      end)
      |> Enum.reduce(%{}, fn row, acc -> Map.merge(acc, row) end)

    grid_map |> Enum.count(fn {k, _v} -> is_visible?(grid_map, k, {width, height}) end)
  end

  defp is_visible?(grid, {x, y}, {width, height}) do
    val = grid[{x, y}]

    [:south, :north, :east, :west]
    |> Enum.map(fn dir -> get_trees(grid, {x, y}, {width, height}, dir) end)
    |> Enum.any?(fn trees -> Enum.all?(trees, fn {_, v} -> v < val end) end)
  end

  defp get_trees(_, {_, y}, {_, height}, :south) when y == height - 1, do: []
  defp get_trees(_, {_, y}, {_, _}, :north) when y == 0, do: []
  defp get_trees(_, {x, _}, {width, _}, :east) when x == width - 1, do: []
  defp get_trees(_, {x, _}, {_, _}, :west) when x == 0, do: []

  defp get_trees(grid, {x, y}, {height, _}, :south),
    do: grid |> Map.take(Enum.map((y + 1)..(height - 1), fn i -> {x, i} end))

  defp get_trees(grid, {x, y}, {_, _}, :north),
    do: grid |> Map.take(Enum.map(0..(y - 1), fn i -> {x, i} end))

  defp get_trees(grid, {x, y}, {width, _}, :east),
    do: grid |> Map.take(Enum.map((x + 1)..(width - 1), fn i -> {i, y} end))

  defp get_trees(grid, {x, y}, {_, _}, :west),
    do: grid |> Map.take(Enum.map(0..(x - 1), fn i -> {i, y} end))

  def part2(_args) do
  end
end
