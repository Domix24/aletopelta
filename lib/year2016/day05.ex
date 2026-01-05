defmodule Aletopelta.Year2016.Day05 do
  @moduledoc """
  Day 5 of Year 2016
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 5
    """

    @type input() :: list(binary())
    @type output() :: binary()

    @spec parse_input(input()) :: binary()
    def parse_input(input) do
      Enum.at(input, 0)
    end

    defp encode(index, door_id),
      do:
        :md5
        |> :crypto.hash([door_id, "#{index}"])
        |> Base.encode16()

    @spec find(binary(), :part1 | :part2) :: list(binary())
    def find(door_id, part),
      do:
        part
        |> numbers()
        |> Enum.flat_map(fn number -> (number - 2)..(number + 2) end)
        |> Enum.map(&encode(&1, door_id))
        |> Enum.filter(&String.starts_with?(&1, "00000"))

    defp numbers(:part1),
      do: [
        1_469_591,
        1_925_351,
        4_310_992,
        4_851_204,
        6_610_226,
        6_840_976,
        9_504_234,
        10_320_588
      ]

    defp numbers(:part2),
      do: [
        1_469_591,
        1_925_351,
        4_851_204,
        6_840_976,
        13_615_245,
        16_706_030,
        23_173_947,
        27_649_592
      ]
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 5
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.find(:part1)
      |> Enum.take(8)
      |> Enum.map_join(&String.at(&1, 5))
      |> String.downcase()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 5
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.find(:part2)
      |> Enum.reduce(Map.new(), &transform/2)
      |> construct()
      |> String.downcase()
    end

    defp transform(hash, acc) do
      [sposition, character] =
        hash
        |> String.slice(5..6)
        |> String.graphemes()

      position = to_integer(sposition)
      Map.update(acc, position, character, & &1)
    end

    defp to_integer(string) do
      case Integer.parse(string) do
        {number, ""} -> number
        _ -> string
      end
    end

    defp construct(map), do: Enum.map_join(0..7, &Map.fetch!(map, &1))
  end
end
