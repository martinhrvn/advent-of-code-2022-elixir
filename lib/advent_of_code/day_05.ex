defmodule AdventOfCode.Day05 do
  def part1(input) do
    parse_and_move(input, true)
  end

  def part2(input) do
    parse_and_move(input)
  end

  defp parse_and_move(input, flip \\ false) do
    [crates_input, moves_input] = String.split(input, "\n\n")

    crates = crates_input |> parse_crates()
    moves = moves_input |> parse_moves

    moves
    |> Enum.reduce(crates, fn m, crates -> move_crates(crates, m, flip) end)
    |> Enum.sort()
    |> Enum.map(fn {_, v} -> hd(v) end)
  end

  defp move_crates(crates, %{from: from, to: to, count: n}, flip) do
    c = Map.get(crates, from) |> Enum.take(n)

    crates
    |> Map.update!(from, fn crates -> Enum.drop(crates, n) end)
    |> Map.update!(to, fn crates ->
      if flip do
        Enum.concat(Enum.reverse(c), crates)
      else
        Enum.concat(c, crates)
      end
    end)
  end

  defp parse_moves(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn line ->
      result = Regex.named_captures(~r/move (?<count>\d+) from (?<from>\d+) to (?<to>\d+)/, line)

      %{
        count: String.to_integer(result["count"]),
        from: String.to_integer(result["from"]),
        to: String.to_integer(result["to"])
      }
    end)
  end

  defp parse_crates(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.drop(-1)
    |> Enum.map(fn line ->
      line
      |> String.to_charlist()
      |> Enum.chunk_every(4)
      |> Enum.map(fn
        [?[, n, ?] | _] -> n
        _ -> nil
      end)
    end)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(fn arr -> arr |> Enum.drop_while(&is_nil/1) end)
    |> Enum.with_index()
    |> Map.new(fn {v, k} -> {k + 1, v} end)
  end
end
