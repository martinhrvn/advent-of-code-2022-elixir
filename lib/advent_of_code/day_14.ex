defmodule AdventOfCode.Day14.Cave do
  defstruct [:bottom, :cave]

  def new(input) do
    cave = %__MODULE__{
      bottom: 0,
      cave: %{}
    }

    input |> Enum.reduce(cave, fn line, cave -> draw_walls(cave, line) end)
  end

  def drop_sand(%__MODULE__{} = cave) do
    drop_sand(cave, {500, 0})
  end

  defp drop_sand(%__MODULE__{bottom: b} = cave, {_, y}) when y > b, do: {:fallen_out, cave}

  defp drop_sand(%__MODULE__{} = cave, {x, y}) do
    s = Map.get(cave.cave, {x, y + 1})
    sw = Map.get(cave.cave, {x - 1, y + 1})
    se = Map.get(cave.cave, {x + 1, y + 1})

    case {sw, s, se} do
      {_, nil, _} -> drop_sand(cave, {x, y + 1})
      {nil, _, _} -> drop_sand(cave, {x - 1, y + 1})
      {_, _, nil} -> drop_sand(cave, {x + 1, y + 1})
      {_, _, _} -> {{x, y}, %{cave | cave: Map.put(cave.cave, {x, y}, :sand)}}
    end
  end

  def draw_walls(%__MODULE__{} = cave, points) do
    points
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.reduce(cave, fn [p1, p2], cave ->
      draw_line(cave, p1, p2)
    end)
  end

  def draw_line(%__MODULE__{} = cave, [x1, y], [x2, y]) do
    x1..x2
    |> Enum.reduce(cave, fn x, cave ->
      put_wall(cave, [x, y])
    end)
  end

  def draw_line(%__MODULE__{} = cave, [x, y1], [x, y2]) do
    y1..y2
    |> Enum.reduce(cave, fn y, cave ->
      put_wall(cave, [x, y])
    end)
  end

  defp put_wall(%__MODULE__{} = cave, [x, y]) do
    bottom =
      case y do
        y when y > cave.bottom -> y
        _ -> cave.bottom
      end

    %{cave | cave: Map.put(cave.cave, {x, y}, :wall), bottom: bottom}
  end
end

defmodule AdventOfCode.Day14 do
  alias AdventOfCode.Day14.Cave

  def part1(input) do
    cave = input |> parse_input()

    cave
    |> Stream.unfold(&Cave.drop_sand/1)
    |> Enum.take_while(fn result -> result != :fallen_out end)
    |> Enum.count()
  end

  def part2(input) do
    cave = input |> parse_input()
    floor_y = cave.bottom + 2
    cave = Cave.draw_line(cave, [-10000, floor_y], [10000, floor_y])

    cave
    |> Stream.unfold(&Cave.drop_sand/1)
    |> Enum.take_while(fn result -> result != {500, 0} end)
    |> length()
    |> then(&(&1 + 1))
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn l ->
      String.split(l, " -> ", trim: true)
      |> Enum.map(fn s -> String.split(s, ",", trim: true) |> Enum.map(&String.to_integer/1) end)
    end)
    |> Cave.new()
  end
end
