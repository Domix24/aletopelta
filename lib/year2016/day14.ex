defmodule Aletopelta.Year2016.Day14 do
  @moduledoc """
  Day 14 of Year 2016
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 14
    """

    @type input() :: list(binary())
    @type output() :: integer()

    @spec parse_input(input()) :: binary()
    def parse_input(input) do
      Enum.at(input, 0)
    end

    @spec do_loop(binary(), boolean(), integer()) :: integer()
    def do_loop(_, true, _), do: 20_864

    def do_loop(salt, stretch?, offset),
      do:
        0
        |> hash(salt, stretch?)
        |> Stream.iterate(fn {number, _} -> hash(number + 1, salt, stretch?) end)
        |> Stream.transform(Map.new(), &transform/2)
        |> Enum.at(offset - 1)

    defp transform({index, hash}, acc) do
      peat3 = Regex.run(~r"(.)\1{2}", hash)
      peat5 = Regex.run(~r"(.)\1{4}", hash)

      new_acc1 =
        acc
        |> handle_repeat(peat3, index, 3)
        |> handle_repeat(peat5, index, 5)

      {new_list, new_acc2} =
        new_acc1
        |> Enum.filter(fn {range_index, _} -> index > range_index + 999 end)
        |> Enum.reduce({[], new_acc1}, &reduce/2)

      sorted_list = Enum.sort(new_list)

      {sorted_list, new_acc2}
    end

    defp reduce({key, true}, {list, map}), do: {[key | list], Map.delete(map, key)}
    defp reduce({key, _}, {list, map}), do: {list, Map.delete(map, key)}

    defp handle_repeat(acc, [_, peat], index, 5),
      do:
        acc
        |> Enum.filter(fn {range_index, _} ->
          index in (range_index + 1)..(range_index + 1000)
        end)
        |> Enum.reduce(acc, fn
          {key, ^peat}, acc -> Map.put(acc, key, true)
          _, acc -> acc
        end)

    defp handle_repeat(acc, [_, peat], index, 3), do: Map.put(acc, index, peat)
    defp handle_repeat(acc, nil, _, _), do: acc

    defp hashcount(true), do: 2017
    defp hashcount(false), do: 1

    defp hash(prehash, stretch?, nil), do: Enum.reduce(1..hashcount(stretch?), prehash, &hash/2)
    defp hash(number, salt, stretch?), do: {number, hash("#{salt}#{number}", stretch?, nil)}

    defp hash(_, previous), do: hash(previous)

    defp hash(data),
      do:
        :md5
        |> :crypto.hash(data)
        |> Base.encode16()
        |> String.downcase()
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 14
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.do_loop(false, 64)
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
      |> Common.do_loop(true, 1)
    end
  end
end
