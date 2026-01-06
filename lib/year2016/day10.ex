defmodule Aletopelta.Year2016.Day10 do
  @moduledoc """
  Day 10 of Year 2016
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 10
    """

    @type input() :: list(binary())
    @type output() :: integer()
    @type bots() :: %{{:bot, integer()} => list({:bot | :output, integer()})}
    @type values() :: %{{:output | :bot, integer()} => list(integer())}

    @spec parse_input(input()) :: {bots(), values()}
    def parse_input(input) do
      input
      |> Enum.map(fn line ->
        line
        |> String.split()
        |> parse_line()
      end)
      |> Enum.sort_by(&elem(&1, 0))
      |> Enum.chunk_by(&elem(&1, 0))
      |> Enum.with_index(fn
        list, 0 -> Map.new(list, fn {:bot, id, rules} -> {id, rules} end)
        list, 1 -> Enum.group_by(list, &elem(&1, 2), &elem(&1, 1))
      end)
      |> format()
    end

    defp parse_line([
           "bot",
           id,
           "gives",
           "low",
           "to",
           low_receiver,
           low_id,
           "and",
           "high",
           "to",
           high_receiver,
           high_id
         ]),
         do:
           {:bot, {:bot, String.to_integer(id)},
            [
              {Enum.at(~w"#{low_receiver}"a, 0), String.to_integer(low_id)},
              {Enum.at(~w"#{high_receiver}"a, 0), String.to_integer(high_id)}
            ]}

    defp parse_line(["value", value, "goes", "to", "bot", bot_id]),
      do: {:value, String.to_integer(value), {:bot, String.to_integer(bot_id)}}

    defp format([bots, values]), do: {bots, values}

    @spec iterate(values(), bots()) :: values()
    def iterate(values, bots) do
      Enum.reduce(values, values, fn
        {key, [_, _ | _] = list}, acc ->
          [mini | sorted] = Enum.sort(list)
          [maxi | new_list] = Enum.reverse(sorted)

          bots
          |> Map.fetch!(key)
          |> Enum.zip_reduce([mini, maxi], acc, fn id, value, acc ->
            Map.update(acc, id, [value], &[value | &1])
          end)
          |> Map.put(key, new_list)

        _, acc ->
          acc
      end)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 10
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> start_loop()
      |> Enum.find_value(fn values ->
        values
        |> Enum.find({{0, nil}, 0}, fn
          {_, [_, _ | _] = list} -> 61 in list and 17 in list
          _ -> false
        end)
        |> elem(0)
        |> elem(1)
      end)
    end

    defp start_loop({bots, values}), do: Stream.iterate(values, &Common.iterate(&1, bots))
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 10
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> start_loop()
      |> Enum.reduce_while(nil, &reduce/2)
      |> Enum.filter(fn {{type, id}, _} -> type === :output and id in 0..2 end)
      |> Enum.product_by(&product/1)
    end

    defp start_loop({bots, values}), do: Stream.iterate(values, &Common.iterate(&1, bots))

    defp product({_, list}), do: Enum.at(list, 0)

    defp alike?({key, value}, compare) do
      sorted = Enum.sort(value)

      case Map.get(compare, key) do
        nil -> false
        list -> Enum.sort(list) === sorted
      end
    end

    defp reduce(values, acc) when map_size(values) === map_size(acc) do
      alike? = Enum.all?(values, &alike?(&1, acc))

      if alike?, do: {:halt, acc}, else: {:cont, values}
    end

    defp reduce(values, _), do: {:cont, values}
  end
end
