defmodule AdventOfCode.Day07 do
  @find_smaller_than 100_000
  @total_disk_space 70_000_000
  @needed_for_update 30_000_000

  def part1(input) do
    input
    |> get_fs()
    |> Enum.filter(fn {_, v, type} -> type == :dir and v < @find_smaller_than end)
    |> total_space()
  end

  def part2(input) do
    fs = input |> get_fs()
    total_occupied = fs |> total_space(:file)
    need_to_free = @needed_for_update - (@total_disk_space - total_occupied)

    fs
    |> Enum.filter(fn {_, v, t} -> t == :dir and v > need_to_free end)
    |> Enum.min_by(fn {_, v, _} -> v end)
    |> elem(1)
  end

  defp get_fs(input) do
    input
    |> String.split("\n")
    |> Enum.reduce({%{}, []}, &cmd/2)
    |> then(fn {tree, _} -> get_sizes(tree) end)
  end

  defp cmd("$ cd /", {tree, _}), do: {tree, []}
  defp cmd("$ cd ..", {tree, [_ | rest]}), do: {tree, rest}
  defp cmd("$ cd " <> dir, {tree, curr_path}), do: {tree, [dir | curr_path]}
  defp cmd("$ ls", {tree, curr_path}), do: {tree, curr_path}

  defp cmd(line, {tree, curr_path}) do
    case String.split(line, " ") do
      ["dir", name] ->
        {put_in(tree, Enum.reverse([name | curr_path]), %{}), curr_path}

      [size, name] ->
        {put_in(tree, Enum.reverse([name | curr_path]), String.to_integer(size)), curr_path}

      _ ->
        {tree, curr_path}
    end
  end

  defp get_sizes(tree, key \\ "/") do
    tree
    |> Enum.reduce([], fn
      {k, v}, acc when is_map(v) ->
        sizes = get_sizes(v, "#{key}/#{k}")

        sum =
          sizes
          |> total_space(:file)

        [{"#{key}/#{k}", sum, :dir} | sizes ++ acc]

      {k, v}, acc ->
        [{"#{key}/#{k}", v, :file} | acc]
    end)
  end

  defp total_space(list, type \\ nil) do
    list
    |> Enum.map(fn {_, v, t} -> if type == nil or t == type, do: v, else: 0 end)
    |> Enum.sum()
  end
end
