defmodule AdventOfCode.Day08 do
  def part1(input) do
    {grid, {width, height}} = parse_grid(input)
    grid |> Enum.count(fn {k, _v} -> is_visible?(grid, k, {width, height}) end)
  end

  def part2(input) do
    {grid, {width, height}} = parse_grid(input)
    grid |> Enum.map(fn {k, _} -> scenic_score(grid, k, {width, height}) end) |> Enum.max()
  end

  defp parse_grid(input) do
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

    {grid_map, {width, height}}
  end

  defp is_visible?(grid, {x, y}, {width, height}) do
    val = grid[{x, y}]

    [:south, :north, :east, :west]
    |> Enum.map(fn dir -> get_trees(grid, {x, y}, {width, height}, dir) end)
    |> Enum.any?(fn trees -> Enum.all?(trees, fn {_, v} -> v < val end) end)
  end

  defp scenic_score(grid, {x, y}, {width, height}) do
    val = grid[{x, y}]

    [:south, :north, :east, :west]
    |> Enum.map(fn dir ->
      grid
      |> get_trees({x, y}, {width, height}, dir)
      |> then(fn
        [] ->
          0

        arr ->
          l = Enum.take_while(arr, fn {_, v} -> v < val end) |> length()

          if l == length(arr) do
            l
          else
            l + 1
          end
      end)
    end)
    |> Enum.product()
  end

  defp get_trees(_, {_, y}, {_, height}, :south) when y == height - 1, do: []
  defp get_trees(_, {_, y}, {_, _}, :north) when y == 0, do: []
  defp get_trees(_, {x, _}, {width, _}, :east) when x == width - 1, do: []
  defp get_trees(_, {x, _}, {_, _}, :west) when x == 0, do: []

  defp get_trees(grid, {x, y}, {height, _}, :south),
    do:
      grid
      |> Map.take(Enum.map((y + 1)..(height - 1), fn i -> {x, i} end))
      |> Enum.sort_by(fn {{_x, y}, _v} -> y end)

  defp get_trees(grid, {x, y}, {_, _}, :north),
    do:
      grid
      |> Map.take(Enum.map(0..(y - 1), fn i -> {x, i} end))
      |> Enum.sort_by(fn {{_x, y}, _v} -> y end, :desc)

  defp get_trees(grid, {x, y}, {width, _}, :east),
    do:
      grid
      |> Map.take(Enum.map((x + 1)..(width - 1), fn i -> {i, y} end))
      |> Enum.sort_by(fn {{x, _y}, _v} -> x end)

  defp get_trees(grid, {x, y}, {_, _}, :west),
    do:
      grid
      |> Map.take(Enum.map(0..(x - 1), fn i -> {i, y} end))
      |> Enum.sort_by(fn {{x, _y}, _v} -> x end, :desc)
end
