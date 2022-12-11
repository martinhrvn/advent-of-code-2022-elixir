defmodule AdventOfCode.Day11 do
  alias AdventOfCode.Day11.MonkeyBusiness
  alias AdventOfCode.Day11.Monkey

  def part1(input) do
    input
    |> run(20, 3)
  end

  def part2(input) do
    input
    |> run(10000, 1)
  end

  defp run(input, n, calming) do
    monkeys = input |> get_monkeys()
    monkeys = MonkeyBusiness.new(monkeys)
    MonkeyBusiness.run(monkeys, n, calming)
  end

  defp get_monkeys(input) do
    input |> String.split("\n\n", trim: true) |> Enum.map(&get_monkey/1)
  end

  defp get_monkey(line) do
    captures =
      Regex.named_captures(
        ~r/Monkey (?<monkey>\d+):\s+Starting items: (?<starting_items>[\d, ]+)\s+Operation: new = (?<operation>(old [+*] (old|\d+)))\s+Test: divisible by (?<test_value>\d+)\s+If true: throw to monkey (?<if_true>\d+)\s+If false: throw to monkey (?<if_false>\d+)/ms,
        line
      )

    Monkey.new(
      captures["monkey"],
      captures["starting_items"],
      captures["operation"],
      captures["test_value"],
      captures["if_true"],
      captures["if_false"]
    )
  end
end

defmodule AdventOfCode.Day11.Monkey do
  defstruct [:id, :items, :operation_fn, :test_value, :pass_monkey, :fail_monkey, :inspections]

  def new(id, items, operation, test_value, pass_monkey, fail_monkey) do
    %__MODULE__{
      id: id,
      items: String.split(items, ", ", trim: true) |> Enum.map(&String.to_integer/1),
      operation_fn: get_operation_fn(operation),
      test_value: String.to_integer(test_value),
      pass_monkey: pass_monkey,
      fail_monkey: fail_monkey,
      inspections: 0
    }
  end

  defp get_operation_fn(operation) do
    case String.split(operation, " ") do
      ["old", "+", "old"] -> fn x -> x + x end
      ["old", "*", "old"] -> fn x -> x * x end
      ["old", "+", operation_value] -> fn x -> x + String.to_integer(operation_value) end
      ["old", "*", operation_value] -> fn x -> x * String.to_integer(operation_value) end
      _ -> fn x -> x end
    end
  end

  def process(monkey, calming, lcm) do
    Enum.reduce(monkey.items, {[], []}, fn item, {pass_values, fail_values} ->
      item = monkey.operation_fn.(item) |> div(calming) |> rem(lcm)

      if rem(item, monkey.test_value) == 0 do
        {[item | pass_values], fail_values}
      else
        {pass_values, [item | fail_values]}
      end
    end)
    |> then(fn {pass_values, fail_values} ->
      {{Enum.reverse(pass_values), Enum.reverse(fail_values)},
       monkey |> clear_items() |> increment_inspections(length(pass_values) + length(fail_values))}
    end)
  end

  def add_items(monkey, items) do
    %__MODULE__{monkey | items: monkey.items ++ items}
  end

  def clear_items(monkey) do
    %__MODULE__{monkey | items: []}
  end

  def increment_inspections(monkey, count) do
    %__MODULE__{monkey | inspections: monkey.inspections + count}
  end
end

defmodule AdventOfCode.Day11.MonkeyBusiness do
  defstruct ids: [], monkeys: %{}, lcm: nil
  alias AdventOfCode.Day11.Monkey

  def new(monkeys) do
    lcm = monkeys |> Enum.reduce(1, fn m, acc -> lcm(m.test_value, acc) end)
    monkey_ids = monkeys |> Enum.map(& &1.id)
    %__MODULE__{ids: monkey_ids, monkeys: Map.new(monkeys, fn m -> {m.id, m} end), lcm: lcm}
  end

  def run(%__MODULE__{} = mb, rounds, calming) do
    1..rounds
    |> Enum.reduce(mb, fn _, mb ->
      round(mb, calming)
    end)
    |> Map.get(:monkeys)
    |> Enum.map(fn {_, m} -> m.inspections end)
    |> Enum.sort(:desc)
    |> Enum.take(2)
    |> Enum.product()
  end

  defp round(%__MODULE__{} = mb, calming) do
    mb.ids
    |> Enum.reduce(mb, fn monkey_id, mb ->
      monkeys = mb.monkeys
      monkey = monkeys[monkey_id]

      {{pass_values, fail_values}, monkey} = Monkey.process(monkey, calming, mb.lcm)

      mb
      |> update_in([Access.key(:monkeys), monkey.pass_monkey, Access.key(:items)], fn items ->
        items ++ pass_values
      end)
      |> update_in([Access.key(:monkeys), monkey.fail_monkey, Access.key(:items)], fn items ->
        items ++ fail_values
      end)
      |> update_in([Access.key(:monkeys), monkey_id], fn _ -> monkey end)
    end)
  end

  defp lcm(a, b), do: div(a * b, Integer.gcd(a, b))
end
