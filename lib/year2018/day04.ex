defmodule Aletopelta.Year2018.Day04 do
  @moduledoc """
  Day 4 of Year 2018
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 4
    """

    @type input() :: list(binary())

    @spec parse_input(input()) :: %{integer() => [{integer(), integer()}]}
    def parse_input(input) do
      input
      |> Enum.sort_by(fn element ->
        ~r"\[(\d+)-(\d+)-(\d+) (\d+):(\d+)\]"
        |> Regex.run(element)
        |> Enum.drop(1)
        |> Enum.join()
        |> String.to_integer()
      end)
      |> Enum.chunk_while(nil, &chunk/2, fn acc -> {:cont, Enum.reverse(acc), nil} end)
      |> Enum.map(&sleep/1)
      |> Enum.group_by(& &1.id, &{&1.sleepinterval, &1.sleeptime})
    end

    defp chunk(element, acc) do
      [_ | rest] = Regex.run(~r"\[(\d+)-(\d+)-(\d+) (\d+):(\d+)\] (.*)$", element)

      [year, month, day, hour, minute] =
        rest
        |> Enum.take(5)
        |> Enum.map(&String.to_integer/1)

      part = Enum.at(rest, -1)

      build_map(%{year: year, month: month, day: day, hour: hour, minute: minute}, part, acc)
    end

    defp build_map(initial, part, acc) do
      case {acc, Regex.run(~r"\d+", part), Regex.run(~r"sleep", part), Regex.run(~r"wake", part)} do
        {nil, [id], nil, nil} ->
          new_initial = Map.put(initial, :id, String.to_integer(id))
          {:cont, [new_initial]}

        {[_ | _], nil, ["sleep"], nil} ->
          new_initial = Map.put(initial, :sleep?, true)
          {:cont, [new_initial | acc]}

        {[_ | _], nil, nil, ["wake"]} ->
          new_initial = Map.put(initial, :wake?, true)
          {:cont, [new_initial | acc]}

        {[_ | _], [id], nil, nil} ->
          new_initial = Map.put(initial, :id, String.to_integer(id))
          {:cont, Enum.reverse(acc), [new_initial]}
      end
    end

    defp sleep(entries) do
      entries
      |> Enum.reduce(nil, fn
        %{id: _} = guard, nil ->
          guard
          |> Map.put(:sleepinterval, [])
          |> Map.put(:sleeptime, 0)

        %{minute: minute, sleep?: true}, guard ->
          Map.put(guard, :sleepstart, minute)

        %{minute: minute1, wake?: true}, %{sleepstart: minute0} = guard ->
          guard
          |> Map.update!(:sleepinterval, &[minute0..(minute1 - 1) | &1])
          |> Map.update!(:sleeptime, &(&1 + minute1 - minute0))
      end)
      |> Map.delete(:sleepstart)
    end

    @spec frequencies([{[Range.t()], integer()}]) :: %{integer() => integer()}
    def frequencies(values) do
      values
      |> Enum.reduce([], fn {ranges, _}, acc ->
        Enum.flat_map(ranges, & &1) ++ acc
      end)
      |> Enum.frequencies()
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 4
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Enum.max_by(&totalsleep/1)
      |> minute()
    end

    defp totalsleep({_, values}) do
      Enum.reduce(values, 0, fn {_, time}, acc -> acc + time end)
    end

    defp minute({id, values}) do
      values
      |> Common.frequencies()
      |> Enum.group_by(&elem(&1, 1), &elem(&1, 0))
      |> Enum.max_by(&elem(&1, 0))
      |> then(fn {_, [max]} -> id * max end)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 4
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Enum.map(&minutes/1)
      |> Enum.max_by(&elem(&1, 2))
      |> then(fn {id, minute, _} -> id * minute end)
    end

    defp minutes({id, values}) do
      values
      |> Common.frequencies()
      |> Enum.max_by(&elem(&1, 1), fn -> {0, 0} end)
      |> then(fn {minute, count} -> {id, minute, count} end)
    end
  end
end
