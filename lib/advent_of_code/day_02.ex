defmodule AdventOfCode.Day02 do
  @win "Z"
  @loss "X"
  @draw "Y"

  @op_rock "A"
  @op_paper "B"
  @op_scissors "C"

  @my_rock "X"
  @my_paper "Y"
  @my_scissors "Z"

  @game_scores %{@win => 6, @loss => 0, @draw => 3}
  @shape_props %{
    @op_rock => {@my_scissors, @my_rock, @my_paper},
    @op_paper => {@my_rock, @my_paper, @my_scissors},
    @op_scissors => {@my_paper, @my_scissors, @my_rock}
  }

  def part1(lines) do
    lines
    |> parse_input()
    |> Enum.map(fn
      [a, b] -> game_result(a, b) + shape_score(b)
    end)
    |> Enum.sum()
  end

  def part2(lines) do
    lines
    |> parse_input()
    |> Enum.map(fn
      [a, result] ->
        @game_scores[result] + (shape_for_result(a, result) |> shape_score())
    end)
    |> Enum.sum()
  end

  defp shape_score(shape) do
    case shape do
      "X" -> 1
      "Y" -> 2
      "Z" -> 3
    end
  end

  defp shape_for_result(a, result) do
    {loss, draw, win} = @shape_props[a]

    case result do
      @win -> win
      @loss -> loss
      @draw -> draw
    end
  end

  defp parse_input(lines) do
    lines
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&String.split(&1, " "))
  end

  defp game_result(a, b) do
    case @shape_props[a] do
      {_, _, ^b} -> @game_scores[@win]
      {^b, _, _} -> @game_scores[@loss]
      _ -> @game_scores[@draw]
    end
  end
end
