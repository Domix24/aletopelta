defmodule Aletopelta.Year2021.Day06 do
  @moduledoc """
  Day 6 of Year 2021
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 6
    """
    @spec parse_input(list(binary())) :: list(integer())
    def parse_input(input) do
      Enum.flat_map(input, fn line ->
        ~r/\d+/
        |> Regex.scan(line)
        |> Enum.map(fn [number] ->
          String.to_integer(number)
        end)
      end)
    end

    @spec do_days(list(integer()), integer()) :: %{integer() => integer()}
    def do_days(fishs, nb_days) do
      frequence = Enum.frequencies(fishs)

      do_days(frequence, 0, nb_days)
    end

    defp do_days(fishs, max_day, max_day), do: fishs

    defp do_days(fishs, current_day, max_day) do
      fishs
      |> Enum.flat_map(&decrease_timer/1)
      |> Enum.group_by(fn {fish, _} -> fish end, fn {_, count} -> count end)
      |> Enum.map(&merge_timer/1)
      |> do_days(current_day + 1, max_day)
    end

    defp decrease_timer({0, count}), do: [{8, count}, {6, count}]
    defp decrease_timer({n, count}), do: [{n - 1, count}]

    defp merge_timer({6, [c1, c2]}), do: {6, c1 + c2}
    defp merge_timer({n, [count]}), do: {n, count}
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 6
    """
    @spec execute(list(binary()), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.do_days(80)
      |> Enum.sum_by(&elem(&1, 1))
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 6
    """
    @spec execute(list(binary()), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.do_days(256)
      |> Enum.sum_by(&elem(&1, 1))
    end
  end
end
