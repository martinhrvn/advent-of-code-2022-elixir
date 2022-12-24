defmodule AdventOfCode.Day12 do
  def part1(input) do
    {graph, start, stop, _map} =
      input
      |> get_grid

    length(Graph.get_shortest_path(graph, start, stop)) - 1
  end

  def part2(input) do
    {graph, _start, stop, map} = input |> get_grid
    tgraph = Graph.transpose(graph)

    lowest =
      Enum.flat_map(map, fn
        {p, 0} -> [p]
        _ -> []
      end)

    paths =
      tgraph
      # |> Graph.bellman_ford(stop)
      |> BellmanFord.call(stop)

    paths
    |> Map.take(lowest)
    |> Map.values()
    |> Enum.min()
  end

  defp get_grid(input) do
    min = ?a - ?a
    max = ?z - ?a

    {map, start, stop} =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&to_charlist/1)
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> Enum.with_index()
        |> Enum.map(fn {c, x} -> {{x, y}, c} end)
      end)
      |> Enum.reduce({%{}, nil, nil}, fn {p, v}, {map, s, e} ->
        case v do
          ?S -> {Map.put(map, p, min), p, e}
          ?E -> {Map.put(map, p, max), s, p}
          _ -> {Map.put(map, p, v - ?a), s, e}
        end
      end)

    graph =
      map
      |> Enum.reduce(Graph.new(), fn {p, v}, graph ->
        {x, y} = p

        graph =
          if map[{x - 1, y}] && v + 1 >= map[{x - 1, y}],
            do: Graph.add_edge(graph, {x, y}, {x - 1, y}, label: [v, map[{x - 1, y}]]),
            else: graph

        graph =
          if map[{x + 1, y}] && v + 1 >= map[{x + 1, y}],
            do: Graph.add_edge(graph, {x, y}, {x + 1, y}, label: [v, map[{x + 1, y}]]),
            else: graph

        graph =
          if map[{x, y - 1}] && v + 1 >= map[{x, y - 1}],
            do: Graph.add_edge(graph, {x, y}, {x, y - 1}, label: [v, map[{x, y - 1}]]),
            else: graph

        graph =
          if map[{x, y + 1}] && v + 1 >= map[{x, y + 1}],
            do: Graph.add_edge(graph, {x, y}, {x, y + 1}, label: [v, map[{x, y + 1}]]),
            else: graph
      end)

    {graph, start, stop, map}
  end
end

defmodule BellmanFord do
  @moduledoc """
  The Bellman–Ford algorithm is an algorithm that computes shortest paths from a single
  source vertex to all of the other vertices in a weighted digraph.
  It is capable of handling graphs in which some of the edge weights are negative numbers
  Time complexity: O(VLogV)
  """

  @doc """
  Returns nil when graph has negative cycle.
  """
  def call(%Graph{vertices: vs, edges: meta}, source) do
    distances = source |> Graph.Utils.vertex_id() |> init_distances(vs)

    weights = Enum.map(meta, &edge_weight/1)

    distances =
      for _ <- 1..map_size(vs),
          {{u, v}, weight} <- weights,
          reduce: distances do
        distances ->
          case distances do
            %{^u => :infinity} ->
              distances

            %{^u => du, ^v => dv} when du + weight < dv ->
              %{distances | v => du + weight}

            _ ->
              distances
          end
      end

    if has_negative_cycle?(distances, weights) do
      nil
    else
      Map.new(distances, fn {k, v} -> {Map.fetch!(vs, k), v} end)
    end
  end

  defp init_distances(vertex_id, vertices) do
    Map.new(vertices, fn
      {id, _vertex} when id == vertex_id -> {id, 0}
      {id, _} -> {id, :infinity}
    end)
  end

  defp edge_weight({e, edge_value}), do: {e, edge_value |> Map.values() |> List.first()}

  defp has_negative_cycle?(%{} = distances, meta) do
    Enum.any?(meta, fn {{u, v}, weight} ->
      %{^u => du, ^v => dv} = distances

      du != :infinity and du + weight < dv
    end)
  end
end
