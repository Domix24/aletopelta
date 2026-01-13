defmodule Aletopelta.Year2016.Day09 do
  @moduledoc """
  Day 9 of Year 2016
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 9
    """

    @type input() :: list(binary())
    @type output() :: integer()
    @type frequency() :: %{integer() => integer()}

    @spec parse_input(input()) :: binary()
    def parse_input(input) do
      Enum.at(input, 0)
    end

    defp find_special(<<special, rest::binary>>, special), do: {"", rest}

    defp find_special(<<number, rest::binary>>, special) do
      {part, new_rest} = find_special(rest, special)

      {<<number, part::binary>>, new_rest}
    end

    @spec decompress(binary(), (frequency(), binary(), integer() -> frequency())) :: frequency()
    def decompress(input, dispatch), do: decompress(Map.new(), input, 1, dispatch)

    defp decompress(map, "", _, _), do: map

    defp decompress(map, <<"(", rest::binary>>, factor, dispatch) do
      {sfirst, rest1} = find_special(rest, ?x)
      {ssecond, rest2} = find_special(rest1, ?))

      [first, second] = Enum.map([sfirst, ssecond], &String.to_integer/1)

      copy = binary_part(rest2, 0, first)
      rest3 = binary_part(rest2, first, String.length(rest2) - first)

      map
      |> dispatch(copy, second, factor, dispatch)
      |> decompress(rest3, factor, dispatch)
    end

    defp decompress(map, <<letter, rest::binary>>, factor, dispatch),
      do:
        map
        |> Map.update(letter, 1 * factor, &(&1 + 1 * factor))
        |> decompress(rest, factor, dispatch)

    defp handle(true, {map, input, factor, dispatch}),
      do: decompress(map, input, factor, dispatch)

    defp handle(map, _), do: map

    defp dispatch(map, input, factor1, factor2, dispatch),
      do:
        map
        |> dispatch.(input, factor1)
        |> handle({map, input, factor1 * factor2, dispatch})
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 9
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.decompress(&decompress/3)
      |> Enum.sum_by(&elem(&1, 1))
    end

    defp decompress(map, "", _), do: map

    defp decompress(map, <<letter, rest::binary>>, factor),
      do:
        map
        |> Map.update(letter, 1 * factor, &(&1 + 1 * factor))
        |> decompress(rest, factor)
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 9
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.decompress(&decompress/3)
      |> Enum.sum_by(&elem(&1, 1))
    end

    defp decompress(_, _, _), do: true
  end
end
