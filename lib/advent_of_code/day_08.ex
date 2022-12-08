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

  defp are_all_lower?(grid, coordinates, val) do
    grid
    |> Map.take(coordinates)
    |> Enum.all?(fn {_, v} -> v < val end)
  end

  defp is_visible?(_, {0, _}, _), do: true
  defp is_visible?(_, {_, 0}, _), do: true
  defp is_visible?(_, {_, y}, {_, height}) when y == height - 1, do: true
  defp is_visible?(_, {x, _}, {width, _}) when x == width - 1, do: true

  defp is_visible?(grid, {x, y}, {width, height}) do
    val = grid[{x, y}]
    from_north = are_all_lower?(grid, Enum.map(0..(y - 1), &{x, &1}), val)
    from_south = are_all_lower?(grid, Enum.map((y + 1)..(height - 1), &{x, &1}), val)
    from_west = are_all_lower?(grid, Enum.map(0..(x - 1), &{&1, y}), val)
    from_east = are_all_lower?(grid, Enum.map((x + 1)..(width - 1), &{&1, y}), val)

    from_north or from_south or from_west or from_east
  end

  def part2(_args) do
  end
end
