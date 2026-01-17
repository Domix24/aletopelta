defmodule Aletopelta.Year2015.Day13 do
  @moduledoc """
  Day 13 of Year 2015
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 13
    """

    @type input() :: list(binary())
    @type output() :: integer()
    @type happiness() :: %{list(atom()) => integer()}

    @spec parse_input(input()) :: happiness()
    def parse_input(input) do
      Map.new(input, fn line ->
        [sname, _, gainloss, samount, _, _, _, _, _, _, ssto] = String.split(line)

        sto = String.trim_trailing(ssto, ".")
        [name, to] = Enum.flat_map([sname, sto], &~w"#{String.downcase(&1)}"a)
        amount = String.to_integer(samount)

        {[name, to], style(gainloss, amount)}
      end)
    end

    defp style("gain", amount), do: amount
    defp style("lose", amount), do: -amount

    @spec execute(happiness(), module()) :: output()
    def execute(happiness, module),
      do:
        happiness
        |> Enum.map(&first_name/1)
        |> Enum.uniq()
        |> prepare(happiness, simply(module))

    defp first_name({[first, _], _}), do: first

    defp simply(module),
      do:
        module
        |> to_string()
        |> String.downcase()
        |> String.split(".")
        |> Enum.take(-1)
        |> Enum.flat_map(&~w"#{&1}"a)
        |> Enum.at(0)

    defp prepare(keys, happiness, :part2), do: prepare([:me | keys], happiness, :part1)

    defp prepare([person | keys], happiness, :part1),
      do:
        keys
        |> permutation()
        |> Enum.max_by(&sum_happiness(&1, person, happiness))
        |> sum_happiness(person, happiness)

    defp sum_happiness(permutation, person, happiness),
      do:
        [person | permutation]
        |> Enum.chunk_every(2, 1, [person])
        |> Enum.flat_map(&[&1, inverse(&1)])
        |> Enum.sum_by(&Map.get(happiness, &1, 0))

    defp inverse([a, b]), do: [b, a]

    defp permutation([]), do: [[]]

    defp permutation(list) do
      for head <- list,
          tail <- permutation(list -- [head]) do
        [head | tail]
      end
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 13
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
    Part 2 of Day 13
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.execute(__MODULE__)
    end
  end
end
