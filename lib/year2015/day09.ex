defmodule Aletopelta.Year2015.Day09 do
  @moduledoc """
  Day 9 of Year 2015
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 9
    """

    @type input() :: list(binary())
    @type output() :: integer()
    @type distances() :: %{{atom(), atom()} => integer()}

    @spec parse_input(input()) :: distances()
    def parse_input(input) do
      input
      |> Enum.flat_map(fn line ->
        [sfrom, "to", sto, "=", sdistance] = String.split(line)

        [from, to] =
          Enum.flat_map([sfrom, sto], fn destination ->
            lower = String.downcase(destination)

            ~w"#{lower}"a
          end)

        distance = String.to_integer(sdistance)

        [{{from, to}, distance}, {{to, from}, distance}]
      end)
      |> Map.new()
    end

    @spec execute(distances()) :: {output(), output()}
    def execute(map),
      do:
        map
        |> Map.keys()
        |> Enum.map(&elem(&1, 0))
        |> Enum.uniq()
        |> permutation()
        |> Enum.min_max_by(&by(&1, map))
        |> prepare()
        |> Enum.map(&by(&1, map))
        |> output()

    defp prepare({min, max}), do: [min, max]
    defp output([min, max]), do: {min, max}

    defp by(list, map),
      do:
        list
        |> Enum.chunk_every(2, 1, :discard)
        |> Enum.sum_by(fn [desta, destb] -> Map.fetch!(map, {desta, destb}) end)

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
    Part 1 of Day 9
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.execute()
      |> elem(0)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 9
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.execute()
      |> elem(1)
    end
  end
end
