defmodule Aletopelta.Year2017.Day04 do
  @moduledoc """
  Day 4 of Year 2017
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 4
    """

    @type input() :: list(binary())
    @type output() :: integer()

    @spec parse_input(input()) :: list(list(binary()))
    def parse_input(input) do
      Enum.map(input, &String.split/1)
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
      |> Enum.count(&handle/1)
    end

    defp handle(passphrase),
      do:
        passphrase
        |> Enum.frequencies()
        |> Enum.all?(&(elem(&1, 1) < 2))
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 4
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Enum.count(&handle/1)
    end

    defp handle([first | rest]) do
      case handle(first, rest) do
        true -> handle(rest)
        false -> false
      end
    end

    defp handle(_), do: true

    defp handle(first, [second | rest]) do
      splitted_first = String.graphemes(first)
      splitted_second = String.graphemes(second)

      count_first = Enum.count(splitted_first)
      count_second = Enum.count(splitted_second)
      count_merged = Enum.count(splitted_first -- splitted_second)

      if count_first === count_second and count_merged < 1 do
        false
      else
        handle(first, rest)
      end
    end

    defp handle(_, []), do: true
  end
end
