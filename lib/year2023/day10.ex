defmodule Aletopelta.Year2023.Day10 do
  @moduledoc """
  Day 10 of Year 2023
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 10
    """
    def parse_input(input) do
      Enum.with_index(input, &parse_line/2)
      |> Enum.flat_map(& &1)
      |> Map.new
    end

    defp parse_line line, row_index do
      String.graphemes(line)
      |> Enum.with_index(&{{&2, row_index}, &1})
    end

    def find_loop map, start do
      find_loop map, start, start, {0, 0}, MapSet.new
    end
    def find_loop map, {x, y} = current, target, direction, visited do
      cond do
        direction != {0, 0} and current == target -> []
        MapSet.member? visited, current -> nil
        !Map.has_key? map, current -> nil
        true ->
          visited = MapSet.put visited, current

          get_delta(map, current, direction)
          |> Enum.map(fn {dx, dy} ->
            find_loop map, {dx + x, dy + y}, target, {dx, dy}, visited
          end)
          |> Enum.reject(&is_nil/1)
          |> Enum.map(&[current | &1])
          |> Enum.at(0)
      end
    end

    defp get_delta map, position, direction do
      case {direction, Map.fetch!(map, position)} do
        {_, "S"} -> determine_delta map, position
        {_, "."} -> []
        {{0, x}, "|"} -> [{0, x}]
        {{x, 0}, "-"} -> [{x, 0}]
        {{0, 1}, "L"} -> [{1, 0}]
        {{-1, 0}, "L"} -> [{0, -1}]
        {{0, 1}, "J"} -> [{-1, 0}]
        {{1, 0}, "J"} -> [{0, -1}]
        {{0, -1}, "7"} -> [{-1, 0}]
        {{1, 0}, "7"} -> [{0, 1}]
        {{0, -1}, "F"} -> [{1, 0}]
        {{-1, 0}, "F"} -> [{0, 1}]
        _ -> []
      end
    end

    defp determine_delta map, {x, y} do
      [{0, -1}, {0, 1}, {-1, 0}, {1, 0}]
      |> Enum.map(fn {dx, dy} -> {{dx, dy}, Map.fetch(map, {x + dx, y + dy})} end)
      |> Enum.reject(fn
        {_, :error} -> true
        {{dx, dy}, _} -> get_delta(map, {dx + x, dy + y}, {dx, dy}) == []
      end)
      |> Enum.take(1)
      |> Enum.map(&elem &1, 0)
    end
 end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 10
    """
    def execute(input) do
      input = Common.parse_input input
      start = Map.filter(input, & elem(&1, 1) == "S") |> Map.keys |> Enum.at(0)

      Common.find_loop(input, start)
      |> get_depth
    end

    defp get_depth list do
      count = Enum.count list
      count / 2
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 10
    """
    def execute(input) do
      input = Common.parse_input input
      start = Map.filter(input, & elem(&1, 1) == "S") |> Map.keys |> Enum.at(0)

      input_total = Map.keys(input) |> Enum.count
      loop = Common.find_loop(input, start)
      loop_total = Enum.count loop

      replace_start(loop, start)
      |> get_sign
      |> then(fn sign -> Map.put input, start, sign end)
      |> fill(MapSet.new(loop), {-1, 0}, {1, 0}, {MapSet.new, MapSet.new}, [outside: true, source: :west])
      |> elem(1)
      |> Enum.count
      |> then(fn outside_count -> input_total - loop_total - outside_count end)
    end

    defp replace_start loop, {sx, sy} do
      [{hx, hy} | _] = Enum.take(loop, 2) |> Enum.reverse
      [{tx, ty} | _] = Enum.reverse loop

      {{hx - sx, hy - sy}, {sx - tx, sy - ty}}
    end

    defp get_sign({{0, 1}, {-1, 0}}), do: "F"
    defp get_sign({{0, -1}, {0, -1}}), do: "|"
    defp get_sign({{0, -1}, {1, 0}}), do: "J"
    defp get_sign({{-1, 0}, {-1, 0}}), do: "-"
    defp get_sign({{0, 1}, {1, 0}}), do: "7"
    defp get_sign({{0, -1}, {-1, 0}}), do: "L"

    defp fill map, loop, {x, y}, {dx, dy} = delta, {visited, outside} = return, state do
      {x, y} = {x + dx, y + dy}
      cell = Map.fetch map, {x, y}
      cond do
        match? :error, cell -> return
        MapSet.member? visited, {x, y} -> return
        state[:outside] and MapSet.member? loop, {x, y} ->
          source = case {delta, state[:source]} do
            {{1, 0}, nil} -> :west
            {{-1, 0}, nil} -> :east
            {{0, 1}, nil} -> :north
            {{0, -1}, nil} -> :south
            {_, source} -> source
          end
          visited = MapSet.put visited, {x, y}
          get_directions(elem(cell, 1), delta, source)
          |> Enum.reduce({visited, outside}, fn {delta, state}, acc ->
            fill map, loop, {x, y}, delta, acc, [outside: true, source: state[:source]]
          end)
        state[:outside] ->
          visited = MapSet.put visited, {x, y}
          outside = MapSet.put outside, {x, y}

          [{1, 0}, {-1, 0}, {0, 1}, {0, -1}]
          |> Enum.reduce({visited, outside}, fn delta, acc ->
            fill map, loop, {x, y}, delta, acc, [outside: true]
          end)
      end
    end

    defp get_directions "|", delta, direction do
      calculate_line delta, direction, [:west, :east], & elem(&1, 0) == 0, & {0, &1}
    end
    defp get_directions "-", delta, direction do
      calculate_line delta, direction, [:north, :south], & elem(&1, 1) == 0, & {&1, 0}
    end

    defp get_directions "F", delta, direction do
      case {delta, direction} do
        {{1, 0}, :west } ->
          [{{1, 0}, [source: :north]},
           {{0, 1}, [source: :west ]},
           {{0, -1}, [source: :south]}]
        {{-1, 0}, :south} ->
          [{{0, 1}, [source: :east ]}]
        {{-1, 0}, :north} ->
          [{{-1, 0}, [source: :east ]},
           {{0, 1}, [source: :west ]},
           {{0, -1}, [source: :south]}]
        {{0, -1}, :west } ->
          [{{1, 0}, [source: :north]},
           {{-1, 0}, [source: :east ]},
           {{0, -1}, [source: :south]}]
        {{0, -1}, :east } ->
          [{{1, 0}, [source: :south]}]
        {{0, 1}, :north} ->
          [{{1, 0}, [source: :north]},
           {{-1, 0}, [source: :east ]},
           {{0, 1}, [source: :west ]}]
      end
    end

    defp get_directions "7", delta, direction do
      case {delta, direction} do
        {{1, 0}, :north} ->
          [{{1, 0}, [source: :west ]},
           {{0, 1}, [source: :east ]},
           {{0, -1}, [source: :south]}]
        {{1, 0}, :south} ->
          [{{0, 1}, [source: :west ]}]
        {{-1, 0}, :east } ->
          [{{-1, 0}, [source: :north]},
           {{0, 1}, [source: :east ]},
           {{0, -1}, [source: :south]}]
        {{0, -1}, :east } ->
          [{{1, 0}, [source: :west ]},
           {{-1, 0}, [source: :north]},
           {{0, -1}, [source: :south]}]
        {{0, -1}, :west } ->
          [{{-1, 0}, [source: :south]}]
        {{0, 1}, :north} ->
          [{{1, 0}, [source: :west ]},
           {{-1, 0}, [source: :north]},
           {{0, 1}, [source: :east ]}]
      end
    end

    defp get_directions "J", delta, direction do
      case {delta, direction} do
        {{0, 1}, :east } ->
          [{{1, 0}, [source: :west ]},
           {{-1, 0}, [source: :south]},
           {{0, 1}, [source: :north]}]
        {{0,  1}, :west } ->
          [{{-1, 0}, [source: :north]}]
        {{1, 0}, :south} ->
          [{{1, 0}, [source: :west ]},
           {{0, 1}, [source: :north]},
           {{0, -1}, [source: :east ]}]
        {{1, 0}, :north} ->
          [{{0, -1}, [source: :west ]}]
        {{-1, 0}, :east } ->
          [{{-1, 0}, [source: :south]},
           {{0, 1}, [source: :north]},
           {{0, -1}, [source: :east ]}]
        {{0, -1}, :south} ->
          [{{1, 0}, [source: :west ]},
           {{-1, 0}, [source: :south]},
           {{0, -1}, [source: :east ]}]
      end
    end

    defp get_directions "L", delta, direction do
      case {delta, direction} do
        {{0, -1}, :south} ->
          [{{1, 0}, [source: :south]},
           {{-1, 0}, [source: :east ]},
           {{0, -1}, [source: :west ]}]
        {{-1, 0}, :south} ->
          [{{-1, 0}, [source: :east ]},
           {{0, 1}, [source: :north]},
           {{0, -1}, [source: :west ]}]
        {{0, 1}, :west } ->
          [{{1, 0}, [source: :south]},
           {{-1, 0}, [source: :east ]},
           {{0, 1}, [source: :north]}]
        {{1, 0}, :west } ->
          [{{1, 0}, [source: :south]},
           {{0, 1}, [source: :north]},
           {{0, -1}, [source: :west ]}]
        {{0, 1}, :east } ->
          [{{1, 0}, [source: :north]}]
        {{-1, 0}, :north} ->
          [{{0, -1}, [source: :east ]}]
      end
    end

    defp calculate_line delta, direction, list, is_empty?, build_tuple do
      if is_empty?.(delta) and direction in list do
        other_direction = Enum.filter(list, & &1 != direction) |> Enum.at(0)
        d = if direction == Enum.at(list, 0), do: -1, else: 1
        {y, x} = build_tuple.(d)
        [{delta, [source: direction]},
         {{x, y}, [source: other_direction]}]
      else
        [{build_tuple.(-1), [source: direction]},
         {build_tuple.(1), [source: direction]}]
      end
    end
  end
end
