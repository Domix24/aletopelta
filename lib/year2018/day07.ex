defmodule Aletopelta.Year2018.Day07 do
  @moduledoc """
  Day 7 of Year 2018
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 7
    """

    @type input() :: list(binary())
    @type grid() :: %{binary() => list(binary())}
    @type output() :: list(%{from: binary(), to: binary()})

    @spec parse_input(input()) :: output()
    def parse_input(input) do
      Enum.map(input, fn line ->
        ~r"(?:\s+)(?<id>[A-Z])(?:\s+)"
        |> Regex.scan(line, capture: [:id])
        |> then(fn [[from], [to]] ->
          %{from: from, to: to}
        end)
      end)
    end

    @spec prepare(output(), integer(), integer()) :: {binary(), integer()}
    def prepare(input, workers, seconds) do
      grid = Enum.group_by(input, & &1.from, & &1.to)
      reqs = Enum.group_by(input, & &1.to, & &1.from)

      [roots | rest] = start(grid, workers, seconds)

      Map.new()
      |> Map.put(:workers, workers)
      |> Map.put(:seconds, seconds)
      |> Map.put(:roots, roots)
      |> Map.put(:rest, Enum.map(rest, &elem(&1, 0)))
      |> Map.put(:grid, grid)
      |> Map.put(:reqs, reqs)
      |> loop()
    end

    defp start(grid, workers, seconds) do
      out_nodes =
        grid
        |> Enum.flat_map(&elem(&1, 1))
        |> Map.new(&{&1, 1})

      grid
      |> Enum.reject(&Map.has_key?(out_nodes, elem(&1, 0)))
      |> take([], [], %{workers: workers, seconds: seconds})
    end

    defp take([], [], answer, %{seconds: seconds}), do: [time(answer, seconds) | []]

    defp take(list, [], answer, %{workers: workers, seconds: seconds})
         when length(answer) === workers,
         do: [time(answer, seconds) | list]

    defp take(list, [root | roots], answer, opts), do: take(list, roots, [root | answer], opts)
    defp take([first | list], [], answer, opts), do: take(list, [], [first | answer], opts)

    defp time(lists, seconds),
      do:
        Enum.map(lists, fn
          {<<number>>, list} -> {<<number>>, list, number + 1 + seconds - ?A}
          {_, _, _} = value -> value
        end)

    defp loop(info, answer \\ {[], 0})

    defp loop(%{roots: []}, {answer_list, answer_seconds}) do
      new_list =
        answer_list
        |> Enum.reverse()
        |> Enum.join()

      {new_list, answer_seconds}
    end

    defp loop(info, {answer_list, answer_seconds}) do
      [{_, _, amount} | _] = Enum.sort_by(info.roots, &elem(&1, 2))

      {zero, not_zero} = split(info, amount)

      new_answer = build_answer(zero, answer_list)
      [old_roots | new_with] = only_req(zero, info, new_answer, not_zero)

      updated_with = Enum.map(new_with, &elem(&1, 0))
      new_roots = Enum.map(old_roots, &map_roots(&1, info))

      info
      |> Map.put(:roots, new_roots)
      |> Map.put(:rest, updated_with)
      |> loop({new_answer, answer_seconds + amount})
    end

    defp split(info, amount) do
      info.roots
      |> Enum.map(&{elem(&1, 0), elem(&1, 1), elem(&1, 2) - amount})
      |> Enum.split_with(&(elem(&1, 2) === 0))
    end

    defp only_req(zero, info, new_answer, not_zero) do
      zero
      |> Enum.flat_map(&elem(&1, 1))
      |> Enum.concat(info.rest)
      |> Enum.uniq()
      |> Enum.sort()
      |> Enum.split_with(fn value ->
        req = Map.get(info.reqs, value, [])
        Enum.all?(req, &Enum.member?(new_answer, &1))
      end)
      |> elem(0)
      |> Enum.map(&{&1, nil})
      |> take(not_zero, [], info)
    end

    defp map_roots({letter, nil, time}, info), do: {letter, Map.get(info.grid, letter, []), time}
    defp map_roots({_, _, _} = value, _), do: value

    defp build_answer(zero, answer_list) do
      zero
      |> Enum.map(&elem(&1, 0))
      |> Enum.sort()
      |> Enum.concat(answer_list)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 7
    """
    @spec execute(Common.input(), []) :: binary()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.prepare(1, 0)
      |> elem(0)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 7
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.prepare(5, 60)
      |> elem(1)
    end
  end
end
