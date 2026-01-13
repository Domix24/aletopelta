defmodule Aletopelta.Year2015.Day04 do
  @moduledoc """
  Day 4 of Year 2015
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 4
    """

    @type input() :: list(binary())
    @type output() :: integer()

    @spec parse_input(input()) :: binary()
    def parse_input(input) do
      Enum.at(input, 0)
    end

    defp hash(salt, number),
      do:
        :md5
        |> :crypto.hash([salt, "#{number}"])
        |> Base.encode16(case: :lower)

    @spec execute(binary(), integer()) :: integer()
    def execute(salt, length), do: execute(salt, length, String.duplicate("0", length))

    defp execute(salt, length, find),
      do:
        0
        |> Stream.iterate(&(&1 + 1))
        |> Stream.map(fn index ->
          salt
          |> hash(index)
          |> String.slice(0..(length - 1))
        end)
        |> Enum.find_index(&(&1 === find))
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 4
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.execute(5)
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
      |> Common.execute(6)
    end
  end
end
