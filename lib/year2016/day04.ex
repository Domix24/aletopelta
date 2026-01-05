defmodule Aletopelta.Year2016.Day04 do
  @moduledoc """
  Day 4 of Year 2016
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 4
    """

    @type input() :: list(binary())
    @type output() :: none()
    @type room() :: {list(binary()), integer(), binary()}

    @spec parse_input(input()) :: list(room())
    def parse_input(input) do
      Enum.map(input, fn line ->
        {name, rest} =
          line
          |> String.split("-")
          |> Enum.split(-1)

        [sector_id, checksum] =
          ~r"(\d+)\[(\w+)"
          |> Regex.run(Enum.at(rest, 0))
          |> Enum.drop(1)
          |> Enum.with_index(fn
            line, 0 -> String.to_integer(line)
            line, 1 -> line
          end)

        {name, sector_id, checksum}
      end)
    end

    @spec valid?(room()) :: boolean()
    def valid?({name, _, checksum}) do
      frequency =
        name
        |> Enum.join()
        |> String.graphemes()
        |> Enum.frequencies()
        |> Enum.sort_by(fn {letter, count} -> {-count, letter} end)
        |> Enum.map(&elem(&1, 0))

      checksum
      |> String.graphemes()
      |> Enum.zip(frequency)
      |> Enum.all?(fn {a, b} -> a === b end)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 4
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Enum.filter(&Common.valid?/1)
      |> Enum.sum_by(&elem(&1, 1))
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 4
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Enum.filter(&Common.valid?/1)
      |> Enum.find(&String.contains?("#{decrypt(&1)}", "pole"))
      |> elem(1)
    end

    defp decrypt({name, sector_id, _}) do
      name
      |> Enum.join(" ")
      |> String.to_charlist()
      |> Enum.map(fn
        letter when letter in ?a..?z -> rem(letter - ?a + sector_id, 26) + ?a
        letter -> letter
      end)
    end
  end
end
