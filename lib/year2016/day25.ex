defmodule Aletopelta.Year2016.Day25 do
  @moduledoc """
  Day 25 of Year 2016
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 25
    """

    @type input() :: list(binary())
    @type output() :: integer()
    @type instruction() :: list(binary())
    @type instructions() :: list(instruction())

    @spec parse_input(input()) :: instructions()
    def parse_input(input) do
      Enum.map(input, &String.split/1)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 25
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> find_target()
      |> find_lowest()
    end

    defp find_target(instructions),
      do:
        instructions
        |> Enum.take(3)
        |> Enum.drop(1)
        |> Enum.product_by(fn [_, number | _] -> String.to_integer(number) end)

    defp find_lowest(target),
      do:
        {0, 0}
        |> Stream.iterate(&iterate/1)
        |> Enum.find_value(fn
          {_, value} when value > target -> value - target
          _ -> nil
        end)

    defp iterate({index, _}), do: {index + 1, iterate(index + 1)}
    defp iterate(index), do: div((4 ** index - 1) * 2, 3)
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 25
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      Common.parse_input(input)
      0
    end
  end
end
