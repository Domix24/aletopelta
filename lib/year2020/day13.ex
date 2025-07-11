defmodule Aletopelta.Year2020.Day13 do
  @moduledoc """
  Day 13 of Year 2020
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 13
    """

    @type input() :: list(binary())

    @spec parse_input(input()) :: {integer(), list({integer(), integer()})}
    def parse_input(input) do
      [timestamp, timetable] = input

      new_timestamp = String.to_integer(timestamp)

      new_timetable =
        timetable
        |> String.split(",")
        |> Enum.with_index()
        |> Enum.reject(&(elem(&1, 0) == "x"))
        |> Enum.map(fn {number, index} -> {index, String.to_integer(number)} end)

      {new_timestamp, new_timetable}
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 13
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> find_timestamp()
      |> Enum.min_by(&elem(&1, 1))
      |> product()
    end

    defp product({time, wait}), do: time * wait

    defp find_timestamp({timestamp, timetable}),
      do:
        timetable
        |> Enum.map(&elem(&1, 1))
        |> find_timestamp(timestamp)

    defp find_timestamp([], _), do: []

    defp find_timestamp([time | table], timestamp),
      do: [{time, rem(time - rem(timestamp, time), time)} | find_timestamp(table, timestamp)]
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 13
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> find_timestamp()
    end

    defp find_timestamp({_, timetable}) do
      find_timestamp(timetable, 1, 0)
    end

    defp find_timestamp([], _, accumulator), do: accumulator

    defp find_timestamp([{index, time} | timetable], increment, accumulator) do
      new_accumulator = find_matching({index, time}, increment, accumulator)
      find_timestamp(timetable, increment * time, new_accumulator)
    end

    defp find_matching({index, time}, increment, accumulator)
         when rem(accumulator + index, time) > 0,
         do: find_matching({index, time}, increment, accumulator + increment)

    defp find_matching(_, _, accumulator), do: accumulator
  end
end
