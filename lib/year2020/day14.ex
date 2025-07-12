defmodule Aletopelta.Year2020.Day14 do
  @moduledoc """
  Day 14 of Year 2020
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 14
    """

    @type input() :: list(binary())
    @type single() :: {list(binary()), list({integer(), list(integer())})}
    @type output() :: list(single())
    @type memory() :: list({integer(), integer()})

    @spec parse_input(input()) :: output()
    def parse_input(input) do
      input
      |> Enum.map(&String.split(&1, " = "))
      |> Enum.chunk_by(fn [type, _] -> type == "mask" end)
      |> Enum.chunk_every(2)
      |> Enum.map(fn [[mask], memories] ->
        new_mask = parse_mask(mask)
        new_memories = Enum.map(memories, &parse_memories/1)
        {new_mask, new_memories}
      end)
    end

    defp parse_mask([_, mask]), do: String.graphemes(mask)

    defp parse_memories(memory),
      do:
        ~r/\d+/
        |> Regex.scan(Enum.join(memory))
        |> Enum.flat_map(fn [string] -> [String.to_integer(string)] end)
        |> to_tuple()

    defp to_tuple([memory, value]), do: {memory, value}

    @spec execute_model(output(), (single() -> memory())) :: integer()
    def execute_model(list, model_function),
      do:
        list
        |> Enum.flat_map(model_function)
        |> Enum.reduce(Map.new(), fn {address, value}, acc -> Map.put(acc, address, value) end)
        |> Enum.sum_by(&elem(&1, 1))
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 14
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.execute_model(&run_model/1)
    end

    defp run_model({mask, memory}), do: Enum.map(memory, &prepare_mask(mask, &1))
    defp prepare_mask(mask, {location, memory}), do: {location, convert_value(mask, memory)}

    defp convert_value(mask, memory),
      do:
        memory
        |> Integer.to_string(2)
        |> String.pad_leading(Enum.count(mask), "0")
        |> String.graphemes()
        |> apply_mask(mask)
        |> Enum.join("")
        |> String.to_integer(2)

    defp apply_mask([], _), do: []
    defp apply_mask([value | memory], ["X" | mask]), do: [value | apply_mask(memory, mask)]
    defp apply_mask([_ | memory], [value | mask]), do: [value | apply_mask(memory, mask)]
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 14
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.execute_model(&run_model/1)
    end

    defp run_model({mask, memory}), do: Enum.flat_map(memory, &prepare_mask(mask, &1))
    defp prepare_mask(mask, {location, memory}), do: convert_value(mask, location, memory)

    defp convert_value(mask, location, memory),
      do:
        location
        |> Integer.to_string(2)
        |> String.pad_leading(Enum.count(mask), "0")
        |> String.graphemes()
        |> apply_mask(mask, [])
        |> Enum.map(&build_location(&1, memory))

    defp build_location(location, memory),
      do:
        location
        |> Enum.reverse()
        |> Enum.join("")
        |> String.to_integer(2)
        |> assign_memory(memory)

    defp assign_memory(location, memory), do: {location, memory}

    defp apply_mask([], _, x), do: x

    defp apply_mask([_ | memory], ["X" | mask], x),
      do:
        control_depth(apply_mask(memory, mask, ["0" | x])) ++
          control_depth(apply_mask(memory, mask, ["1" | x]))

    defp apply_mask([me | memory], [ma | mask], x) when ma == "1" or me == "1",
      do: apply_mask(memory, mask, ["1" | x])

    defp apply_mask([_ | memory], [_ | mask], x), do: apply_mask(memory, mask, ["0" | x])

    defp control_depth([value | _] = list) when value in ["0", "1"], do: [list]
    defp control_depth(list), do: list
  end
end
