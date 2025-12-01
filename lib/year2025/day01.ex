defmodule Aletopelta.Year2025.Day01 do
  @moduledoc """
  Day 1 of Year 2025
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 1
    """

    @type input() :: list(binary())
    @type direction() :: :L | :R
    @type rotation() :: {direction(), integer()}

    @spec parse_input(input()) :: list(rotation())
    def parse_input(input) do
      Enum.map(input, fn line ->
        [_, direction, number] =
          ~r"([L|R])(\d+)"
          |> Regex.scan(line)
          |> Enum.at(0)

        new_direction = Enum.at(~w"#{direction}"a, 0)
        new_number = String.to_integer(number)

        {new_direction, new_number}
      end)
    end

    @spec do_reduce(rotation(), {integer(), integer(), integer()}) ::
            {integer(), integer(), integer()}
    def do_reduce({direction, number}, {actual, passed, clicked}) when number > 99,
      do:
        do_reduce(
          {direction, rem(number, 100)},
          {actual, passed, clicked + abs(div(number, 100))}
        )

    def do_reduce(movement, {actual, passed, clicked}),
      do:
        movement
        |> handle_movement(actual)
        |> handle_clicked(actual, clicked)
        |> increment_passed(passed)

    defp handle_movement({:L, number}, actual),
      do: {actual - number, rem(actual + 100 - number, 100)}

    defp handle_movement({:R, number}, actual), do: {actual + number, rem(actual + number, 100)}

    defp handle_clicked({_, remainder}, 0, clicked), do: {remainder, clicked}
    defp handle_clicked({sum, remainder}, _, clicked) when sum < 1, do: {remainder, clicked + 1}
    defp handle_clicked({sum, remainder}, _, clicked) when sum > 99, do: {remainder, clicked + 1}
    defp handle_clicked({_, remainder}, _, clicked), do: {remainder, clicked}

    defp increment_passed({0, clicked}, passed), do: {0, passed + 1, clicked}
    defp increment_passed({number, clicked}, passed), do: {number, passed, clicked}
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 1
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Enum.reduce({50, 0, 0}, &Common.do_reduce/2)
      |> elem(1)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 1
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Enum.reduce({50, 0, 0}, &Common.do_reduce/2)
      |> elem(2)
    end
  end
end
