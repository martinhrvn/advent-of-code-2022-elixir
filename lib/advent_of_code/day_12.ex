defmodule AdventOfCode.Day12 do
  def part1(input) do
    input
    |> get_grid()
    |> then(fn grid -> grid |> PathSearch.find_path(grid[:start], grid[:end]) end)
    |> then(fn l -> length(l) - 1 end)
  end

  def part2(_args) do
  end

  defp get_grid(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_charlist/1)
    |> Stream.with_index()
    |> Enum.flat_map(fn {line, i} ->
      line
      |> Stream.with_index()
      |> Enum.flat_map(fn
        {?S, j} -> [{:start, {i, j}}, {{i, j}, ?a}]
        {?E, j} -> [{:end, {i, j}}, {{i, j}, ?z}]
        {cell, j} -> [{{i, j}, cell}]
      end)
    end)
    |> Map.new()
  end
end

defmodule PathSearch do
  def find_path(grid, start, goal) do
    neighbors = find_neighbors(grid, start)
    paths = Enum.map(neighbors, fn n -> {[start], n} end)
    queue = Enum.reduce(paths, :queue.new(), fn p, q -> :queue.in(p, q) end)
    find_path(grid, queue, goal, MapSet.new()) |> IO.inspect()
  end

  def find_path(grid, queue, goal, visited) do
    case :queue.out(queue) do
      {{:value, {path, node}}, queue} ->
        if node == goal do
          [node | path] |> Enum.reverse()
        else
          if MapSet.member?(visited, node) do
            find_path(grid, queue, goal, visited)
          else
            new_path = [node | path]

            new_queue =
              find_neighbors(grid, node)
              |> Enum.map(fn n -> {new_path, n} end)
              |> Enum.reduce(queue, fn e, q -> :queue.in(e, q) end)

            new_visited = MapSet.put(visited, node)
            find_path(grid, new_queue, goal, new_visited)
          end
        end

      {:empty, _} ->
        nil
    end
  end

  defp find_neighbors(grid, {x, y}) do
    curr = grid[{x, y}]

    [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]
    |> Enum.filter(fn n ->
      case Map.get(grid, n) do
        n when n in (curr - 1)..(curr + 1) -> true
        _ -> false
      end
    end)
  end
end
