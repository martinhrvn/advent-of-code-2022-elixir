defmodule AdventOfCode.Day12Test do
  use ExUnit.Case

  import AdventOfCode.Day12

  test "part1" do
    input = """
    Sabqponm
    abcryxxl
    accszExk
    acctuvwj
    abdefghi
    """

    result = part1(input)

    assert result == 31
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
