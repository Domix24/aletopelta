defmodule Aletopelta.Year2015.Day15 do
  @moduledoc """
  Day 15 of Year 2015
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 15
    """

    @type input() :: list(binary())
    @type output() :: integer()
    @type ingredients() :: list({atom(), list({atom(), integer()})})

    @spec parse_input(input()) :: ingredients()
    def parse_input(input) do
      Enum.map(input, fn line ->
        [name | orest] =
          ~r"[a-z0-9-]+"
          |> Regex.scan(String.downcase(line))
          |> Enum.flat_map(&convert/1)

        rest =
          orest
          |> Enum.chunk_every(2)
          |> Enum.map(fn [name, amount] -> {name, amount} end)

        {name, rest}
      end)
    end

    defp convert([input]) do
      case Regex.scan(~r"\d+", input) do
        [] -> ~w"#{input}"a
        _ -> [String.to_integer(input)]
      end
    end

    @spec execute(ingredients(), module()) :: output()
    def execute(ingredients, part),
      do:
        part
        |> simply()
        |> execute(ingredients, :internal)

    defp execute(part, ingredients, :internal),
      do:
        100
        |> distribute(length(ingredients))
        |> Enum.max_by(&by(&1, ingredients, part))
        |> by(ingredients, part)

    defp by(composition, ingredients, part),
      do:
        composition
        |> Enum.zip_with(ingredients, fn factor, {_, properties} ->
          Enum.map(properties, fn {name, value} -> {name, value * factor} end)
        end)
        |> Enum.zip_with(& &1)
        |> Enum.product_by(fn [first | _] = list ->
          list
          |> Enum.sum_by(&elem(&1, 1))
          |> keep(first, part)
          |> max(0)
        end)

    defp keep(500, {:calories, _}, :part2), do: 1
    defp keep(_, {:calories, _}, :part2), do: 0
    defp keep(_, {:calories, _}, _), do: 1
    defp keep(amount, _, _), do: amount

    defp distribute(sum, k) when sum < 0, do: distribute(0, k)
    defp distribute(sum, 1), do: [[sum]]

    defp distribute(sum, k) do
      for i <- 0..sum,
          rest <- distribute(sum - i, k - 1) do
        [i | rest]
      end
    end

    defp simply(module),
      do:
        module
        |> to_string()
        |> String.downcase()
        |> String.split(".")
        |> Enum.take(-1)
        |> Enum.flat_map(&~w"#{&1}"a)
        |> Enum.at(0)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 15
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.execute(__MODULE__)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 15
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.execute(__MODULE__)
    end
  end
end
