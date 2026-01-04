defmodule Aletopelta.Year2017.Day24 do
  @moduledoc """
  Day 24 of Year 2017
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 24
    """

    @type input() :: list(binary())
    @type output() :: integer()
    @type bridges() :: list(list(integer()))
    @type function(t) :: (t -> t)

    @spec parse_input(input()) :: bridges()
    def parse_input(input) do
      Enum.map(input, fn line ->
        ~r"\d+"
        |> Regex.scan(line)
        |> Enum.flat_map(& &1)
        |> Enum.map(&String.to_integer/1)
      end)
    end

    @spec find_bridges(bridges(), function(integer()), function(integer()), (integer(),
                                                                             integer(),
                                                                             integer() ->
                                                                               integer())) ::
            integer()
    @spec find_bridges(
            bridges(),
            function({integer, integer()}),
            function({integer(), integer()}),
            ({integer(), integer()}, integer(), integer() -> {integer(), integer()})
          ) :: {integer(), integer()}
    def find_bridges(bridges, initialize, fallback, increment) do
      bridges
      |> Enum.with_index(&{&2, &1})
      |> Map.new()
      |> find_bridges(0, initialize.(), fallback, increment)
    end

    defp find_bridges(bridges, port, options, fallback, increment) do
      bridges
      |> Enum.flat_map(fn
        {index, [^port, other]} -> [{index, port, other}]
        {index, [other, ^port]} -> [{index, port, other}]
        _ -> []
      end)
      |> Enum.map(fn {index, porta, portb} ->
        bridges
        |> Map.delete(index)
        |> find_bridges(portb, increment.(options, porta, portb), fallback, increment)
      end)
      |> Enum.max(fn -> fallback.(options) end)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 24
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.find_bridges(&initialize/0, &fallback/1, &increment/3)
    end

    defp initialize, do: 0
    defp fallback(strength), do: strength
    defp increment(strength, porta, portb), do: strength + porta + portb
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 24
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.find_bridges(&initialize/0, &fallback/1, &increment/3)
      |> elem(1)
    end

    defp initialize, do: {0, 0}
    defp fallback({strength, length}), do: {length, strength}
    defp increment({strength, length}, porta, portb), do: {strength + porta + portb, length + 1}
  end
end
