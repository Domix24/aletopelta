defmodule Aletopelta.Year2015.Day14 do
  @moduledoc """
  Day 14 of Year 2015
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 14
    """

    @type input() :: list(binary())
    @type output() :: integer()
    @type reindeer() :: {atom(), integer(), integer(), integer()}

    @spec parse_input(input()) :: list(reindeer())
    def parse_input(input) do
      Enum.map(input, fn line ->
        [sname, _, _, sspeed, _, _, stime, _, _, _, _, _, _, srest | _] = String.split(line)

        [name] =
          [sname]
          |> Enum.map(&String.downcase/1)
          |> Enum.flat_map(&~w"#{&1}"a)

        [speed, time, rest] = Enum.map([sspeed, stime, srest], &String.to_integer/1)

        {name, speed, time, rest}
      end)
    end

    @spec move(reindeer(), integer()) :: integer()
    def move({_, speed, time, rest}, amount),
      do: div(amount, time + rest) * (speed * time) + speed * min(time, rem(amount, time + rest))
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 14
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Enum.map(fn reindeer ->
        Common.move(reindeer, 2503)
      end)
      |> Enum.max()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 14
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> do_loop()
      |> Enum.at(2503)
      |> elem(1)
      |> Map.values()
      |> Enum.max()
    end

    defp do_loop(reindeers),
      do:
        reindeers
        |> initialize()
        |> Stream.iterate(&iterate(&1, reindeers))

    defp initialize(reindeers), do: {0, Map.new(reindeers, fn {name, _, _, _} -> {name, 0} end)}

    defp iterate({index, points}, reindeers), do: iterate(index + 1, points, reindeers)

    defp iterate(index, points, reindeers),
      do:
        reindeers
        |> Enum.group_by(&Common.move(&1, index), fn {name, _, _, _} -> name end)
        |> Enum.max_by(&elem(&1, 0))
        |> elem(1)
        |> Enum.reduce(points, fn name, map -> Map.update!(map, name, &(&1 + 1)) end)
        |> organize(index)

    defp organize(points, index), do: {index, points}
  end
end
