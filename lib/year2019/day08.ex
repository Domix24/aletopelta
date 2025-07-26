defmodule Aletopelta.Year2019.Day08 do
  @moduledoc """
  Day 8 of Year 2019
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 8
    """

    @type input() :: list(binary())

    @spec parse_input(input()) :: list(list(binary()))
    def parse_input(input) do
      input
      |> Enum.at(0)
      |> String.graphemes()
      |> Enum.chunk_every(25 * 6)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 8
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Enum.map(&Enum.frequencies/1)
      |> Enum.min_by(fn %{"0" => zero} -> zero end)
      |> do_product()
    end

    defp do_product(%{"1" => one, "2" => two}), do: one * two
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 8
    """
    @spec execute(Common.input(), []) :: list(binary())
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Enum.reduce(&map/2)
      |> Enum.chunk_every(25)
      |> Enum.map(&Enum.join/1)
    end

    defp map([], _), do: []

    defp map([_ | rest_layer], [top | rest_top]) when top in ["0", "1"],
      do: [top | map(rest_layer, rest_top)]

    defp map([lay | rest_layer], [_ | rest_top]), do: [lay | map(rest_layer, rest_top)]
  end
end
