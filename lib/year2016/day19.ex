defmodule Aletopelta.Year2016.Day19 do
  @moduledoc """
  Day 19 of Year 2016
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 19
    """

    @type input() :: list(binary())
    @type output() :: integer()

    @spec parse_input(input()) :: output()
    def parse_input(input) do
      input
      |> Enum.at(0)
      |> String.to_integer()
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 19
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> do_loop()
    end

    defp do_loop(number_elves) do
      scale = 2 ** floor(:math.log2(number_elves))

      2 * (number_elves - scale) + 1
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 19
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> do_loop()
    end

    defp do_loop(number_elves) do
      scale = 3 ** floor(:math.log(number_elves) / :math.log(3))

      if scale === number_elves do
        number_elves
      else
        number_elves - scale + max(0, number_elves - 2 * scale)
      end
    end
  end
end
