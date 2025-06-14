defmodule Aletopelta.Year2021.Day15 do
  @moduledoc """
  Day 15 of Year 2021
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 15
    """

    @type input() :: [binary()]
    @type grid() :: %{{integer(), integer()} => integer()}

    @spec parse_input(input()) :: grid()
    def parse_input(input) do
      input
      |> Enum.reduce({0, %{}}, fn line, {y, map} ->
        {y + 1, parse_line(line, {0, y}, map)}
      end)
      |> elem(1)
    end

    defp parse_line("", _, map), do: map

    defp parse_line(<<sign, rest::binary>>, {x, y}, map) do
      new_map = Map.put(map, {x, y}, String.to_integer(<<sign>>))
      parse_line(rest, {x + 1, y}, new_map)
    end

    @spec find_path(grid()) :: integer()
    def find_path(map) do
      {{max_x, _}, _} = Enum.max_by(map, &elem(elem(&1, 0), 0))
      {{_, max_y}, _} = Enum.max_by(map, &elem(elem(&1, 0), 1))

      queue = %{
        buckets: %{},
        min_priority: nil,
        size: 0
      }

      do_find(%{
        grid: map,
        risks: %{{0, 0} => 0},
        target: {max_x, max_y},
        queue: push_queue(queue, 0, {0, 0})
      })
    end

    defp do_find(%{target: target, risks: risks, queue: queue} = state) do
      {current, new_queue} = pop_queue(queue)

      if current == target do
        Map.fetch!(risks, current)
      else
        state
        |> Map.put(:queue, new_queue)
        |> get_siblings(current)
        |> do_find()
      end
    end

    defp get_siblings(%{grid: grid, risks: risks} = state, {x, y} = current) do
      current_risk = Map.fetch!(risks, current)

      [{x, y - 1}, {x - 1, y}, {x + 1, y}, {x, y + 1}]
      |> Enum.filter(&Map.has_key?(grid, &1))
      |> process_siblings({current_risk, grid}, state)
    end

    defp process_siblings([], _, acc), do: acc

    defp process_siblings(
           [sibling | others],
           {current_risk, grid} = info,
           %{risks: acc_risks, queue: acc_queue} = acc
         ) do
      grid_risk = Map.fetch!(grid, sibling)
      new_risk = current_risk + grid_risk
      old_risk = Map.get(acc_risks, sibling)

      if old_risk == nil or new_risk < old_risk do
        new_risks = Map.put(acc_risks, sibling, new_risk)
        new_queue = push_queue(acc_queue, new_risk, sibling)
        process_siblings(others, info, %{acc | risks: new_risks, queue: new_queue})
      else
        process_siblings(others, info, acc)
      end
    end

    defp push_queue(
           %{buckets: buckets, min_priority: min_priority, size: size} = queue,
           priority,
           item
         ) do
      new_buckets = Map.update(buckets, priority, [item], &[item | &1])

      new_min =
        case min_priority do
          nil -> priority
          current when priority < current -> priority
          current -> current
        end

      %{queue | buckets: new_buckets, min_priority: new_min, size: size + 1}
    end

    defp pop_queue(%{buckets: buckets, min_priority: min_priority} = queue) do
      pop_queue(queue, Map.fetch!(buckets, min_priority))
    end

    defp pop_queue(%{buckets: buckets, min_priority: min_priority, size: size} = queue, [item]) do
      new_buckets = Map.delete(buckets, min_priority)

      new_min =
        if size > 1 do
          new_buckets
          |> Map.keys()
          |> Enum.min()
        else
          nil
        end

      new_queue = %{queue | buckets: new_buckets, min_priority: new_min, size: size - 1}
      {item, new_queue}
    end

    defp pop_queue(%{buckets: buckets, min_priority: min_priority, size: size} = queue, [
           item | rest
         ]) do
      new_buckets = Map.put(buckets, min_priority, rest)

      new_queue = %{queue | buckets: new_buckets, size: size - 1}
      {item, new_queue}
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 15
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.find_path()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 15
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> upgrade_map()
      |> Common.find_path()
    end

    defp upgrade_map(map) do
      keys = Map.keys(map)
      {max_x, _} = Enum.max_by(keys, &elem(&1, 0))
      {_, max_y} = Enum.max_by(keys, &elem(&1, 1))

      horizontal_size = Range.size(0..max_x)
      vertical_size = Range.size(0..max_y)

      Enum.reduce(map, map, fn {{x, y}, risk}, acc_map ->
        0..4
        |> Enum.flat_map(&change_horizontal({x, y}, {horizontal_size, vertical_size}, risk, &1))
        |> Map.new()
        |> Map.merge(acc_map)
      end)
    end

    defp change_horizontal({x, y}, {horizontal_size, vertical_size}, risk, increment_x) do
      Enum.map(0..4, fn increment_y ->
        new_x = x + increment_x * horizontal_size
        new_y = y + increment_y * vertical_size
        new_risk = rem(risk + increment_x + increment_y - 1, 9) + 1
        {{new_x, new_y}, new_risk}
      end)
    end
  end
end
