defmodule Aletopelta.Year2025.Day12 do
  @moduledoc """
  Day 12 of Year 2025
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 12
    """

    @type input() :: list(binary())
    @type output() :: integer()
    @type boxes() :: %{integer() => integer()}
    @type regions() :: list({list(integer()), integer()})

    @spec parse_input(input()) :: {boxes(), regions()}
    def parse_input(input) do
      input
      |> Enum.map_reduce(:start, &prepare_line/2)
      |> elem(0)
      |> Enum.reject(&is_nil/1)
      |> Enum.split_with(&(elem(&1, 0) === :box))
      |> remove_head()
    end

    defp prepare_line(line, :start) do
      case Regex.scan(~r"\d+", line) do
        [[id]] ->
          {nil, {:box, {String.to_integer(id), 0}}}

        region ->
          [wide, long | presents] =
            Enum.flat_map(region, fn [string] -> [String.to_integer(string)] end)

          {{:region, parse_region(long, wide, presents)}, :start}
      end
    end

    defp prepare_line("", {:box, {id, content}}), do: {{:box, parse_box(id, content)}, :start}

    defp prepare_line(line, {:box, {id, occupied}}),
      do: {nil, {:box, {id, occupied + String.count(line, "#")}}}

    defp parse_region(long, wide, presents), do: {presents, long * wide}
    defp parse_box(id, occupied), do: {id, occupied}

    defp remove_head({old_list1, old_list2}) do
      list1 = Map.new(old_list1, &elem(&1, 1))
      list2 = Enum.map(old_list2, &elem(&1, 1))

      {list1, list2}
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 12
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> begin()
    end

    defp begin({boxes, regions}), do: Enum.count(regions, &small?(&1, boxes))

    defp small?({quantities, size}, boxes),
      do:
        quantities
        |> Enum.with_index(&(&1 * Map.fetch!(boxes, &2)))
        |> Enum.sum()
        |> Kernel.<(size)
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 12
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, []) do
      Common.parse_input(input)
      0
    end
  end
end
