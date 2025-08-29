defmodule Aletopelta.Year2019.Day18 do
  @moduledoc """
  Day 18 of Year 2019
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 18
    """

    @type input() :: list(binary())
    @type position() :: {integer(), integer()}
    @type cell() :: binary()
    @type graph() :: %{position() => %{position() => {integer(), integer()}}}
    @type output() :: %{position() => cell()}

    @spec parse_input(input()) :: output()
    def parse_input(input) do
      input
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {line, y}, acc ->
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {cell, x}, acc_line ->
          Map.put(acc_line, {x, y}, cell)
        end)
      end)
    end

    @spec build_graph(output(), [position()]) :: graph()
    def build_graph(map, positions) do
      Enum.reduce(positions, %{}, fn start_pos, acc ->
        paths = start_loop(map, start_pos)
        Map.put(acc, start_pos, paths)
      end)
    end

    defp start_loop(map, start_pos) do
      queue = :queue.in({start_pos, 0, 0}, :queue.new())
      visited = MapSet.new([start_pos])

      do_loop(map, queue, visited, %{})
    end

    defp do_loop(map, queue, visited, paths) do
      case :queue.out(queue) do
        {:empty, _} ->
          paths

        {{:value, value}, new_queue} ->
          process_queue(map, new_queue, visited, paths, value)
      end
    end

    defp process_queue(map, new_queue, visited, paths, {{x, y}, dist, doors_mask}) do
      neighbors = [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]

      {updated_queue, updated_visited, updated_paths} =
        Enum.reduce(neighbors, {new_queue, visited, paths}, fn pos, {_, v, _} = acc ->
          if MapSet.member?(v, pos) do
            acc
          else
            map
            |> Map.get(pos)
            |> build_queue(pos, acc, dist, doors_mask)
          end
        end)

      do_loop(map, updated_queue, updated_visited, updated_paths)
    end

    defp build_queue(nil, _, acc, _, _), do: acc

    defp build_queue(<<char>>, pos, {q, v, p}, dist, doors_mask) when char in [?., ?@] do
      new_v = MapSet.put(v, pos)
      new_q = :queue.in({pos, dist + 1, doors_mask}, q)
      {new_q, new_v, p}
    end

    defp build_queue(<<char>>, pos, {q, v, p}, dist, doors_mask) when char in ?a..?z do
      new_v = MapSet.put(v, pos)
      new_q = :queue.in({pos, dist + 1, doors_mask}, q)
      new_p = Map.put(p, pos, {dist + 1, doors_mask})
      {new_q, new_v, new_p}
    end

    defp build_queue(<<char>>, pos, {q, v, p}, dist, doors_mask) when char in ?A..?Z do
      door_bit = Bitwise.<<<(1, char - ?A)
      new_doors_mask = Bitwise.bor(doors_mask, door_bit)
      new_v = MapSet.put(v, pos)
      new_q = :queue.in({pos, dist + 1, new_doors_mask}, q)
      {new_q, new_v, p}
    end

    defp build_queue(_, _, acc, _, _), do: acc

    @spec get_path(graph(), position(), position()) :: :unreachable | {integer(), integer()}
    def get_path(graph, from, to) do
      graph
      |> Map.get(from, %{})
      |> Map.get(to, :unreachable)
    end

    @spec add_infinity(:infinity | integer(), integer()) :: :infinity | integer()
    def add_infinity(:infinity, _), do: :infinity
    def add_infinity(cost, distance), do: cost + distance

    @spec get_keys(output()) :: {[{integer(), position()}], %{integer() => position()}, integer()}
    def get_keys(map) do
      keys =
        map
        |> Enum.filter(fn {_, <<cell>>} -> cell >= ?a and cell <= ?z end)
        |> Enum.map(fn {pos, <<key>>} -> {key - ?a, pos} end)
        |> Enum.sort()

      positions = Map.new(keys, fn {idx, pos} -> {idx, pos} end)
      count = length(keys)
      mask = Bitwise.<<<(1, count) - 1

      {keys, positions, mask}
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 18
    """
    @spec execute(Common.input(), []) :: number()
    def execute(input, _) do
      map = Common.parse_input(input)

      entrance =
        map
        |> Enum.find(fn {_, cell} -> cell == "@" end)
        |> elem(0)

      {keys, key_positions, mask} = Common.get_keys(map)

      all_positions = [entrance | Enum.map(keys, fn {_, pos} -> pos end)]
      graph = Common.build_graph(map, all_positions)

      memo = :ets.new(:memo, [:set, :private])

      try do
        result = do_solve(entrance, 0, mask, graph, key_positions, memo)
        if result == :infinity, do: -1, else: result
      after
        :ets.delete(memo)
      end
    end

    defp do_solve(_, mask, mask, _, _, _), do: 0

    defp do_solve(position, owned_mask, target_mask, graph, key_positions, memo) do
      state = {position, owned_mask}

      case :ets.lookup(memo, state) do
        [{^state, cached_result}] ->
          cached_result

        [] ->
          costs =
            key_positions
            |> Enum.filter(fn {key_idx, _} ->
              key_bit = Bitwise.<<<(1, key_idx)
              Bitwise.band(owned_mask, key_bit) == 0
            end)
            |> Enum.map(fn key_info ->
              map_cost(position, owned_mask, target_mask, graph, key_positions, memo, key_info)
            end)
            |> Enum.reject(&(&1 == :infinity))

          result =
            case costs do
              [] -> :infinity
              costs -> Enum.min(costs)
            end

          :ets.insert(memo, {state, result})
          result
      end
    end

    defp map_cost(
           position,
           owned_mask,
           target_mask,
           graph,
           key_positions,
           memo,
           {key_idx, key_pos}
         ) do
      case Common.get_path(graph, position, key_pos) do
        {distance, required_doors} ->
          if Bitwise.band(required_doors, owned_mask) == required_doors do
            key_bit = Bitwise.<<<(1, key_idx)
            new_owned = Bitwise.bor(owned_mask, key_bit)

            key_pos
            |> do_solve(new_owned, target_mask, graph, key_positions, memo)
            |> Common.add_infinity(distance)
          else
            :infinity
          end

        :unreachable ->
          :infinity
      end
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 18
    """
    @spec execute(Common.input(), []) :: number()
    def execute(input, _) do
      map = Common.parse_input(input)

      modified_map = modify_map(map)
      starting_positions = get_entrance(modified_map)
      {keys, positions, mask} = Common.get_keys(modified_map)

      all_positions = starting_positions ++ Enum.map(keys, fn {_, pos} -> pos end)
      graph = Common.build_graph(modified_map, all_positions)

      memo = :ets.new(:memo, [:set, :private])

      try do
        [pos1, pos2, pos3, pos4] = starting_positions
        result = solve_robots({pos1, pos2, pos3, pos4}, 0, mask, graph, positions, memo)
        if result == :infinity, do: -1, else: result
      after
        :ets.delete(memo)
      end
    end

    defp get_entrance(map) do
      map
      |> Enum.filter(fn {_, cell} -> cell == "@" end)
      |> Enum.map(fn {pos, _} -> pos end)
      |> Enum.sort()
    end

    defp modify_map(map) do
      {entrance_pos, _} = Enum.find(map, fn {_, cell} -> cell == "@" end)
      {ex, ey} = entrance_pos

      Map.new(map, &modify_map(&1, ex, ey))
    end

    defp modify_map({{x, y} = position, _}, x, y), do: {position, "#"}
    defp modify_map({{px, y} = position, _}, x, y) when px == x - 1, do: {position, "#"}
    defp modify_map({{px, y} = position, _}, x, y) when px == x + 1, do: {position, "#"}
    defp modify_map({{x, py} = position, _}, x, y) when py == y - 1, do: {position, "#"}
    defp modify_map({{x, py} = position, _}, x, y) when py == y + 1, do: {position, "#"}

    defp modify_map({{px, py} = position, _}, x, y) when px == x - 1 and py == y - 1,
      do: {position, "@"}

    defp modify_map({{px, py} = position, _}, x, y) when px == x + 1 and py == y - 1,
      do: {position, "@"}

    defp modify_map({{px, py} = position, _}, x, y) when px == x - 1 and py == y + 1,
      do: {position, "@"}

    defp modify_map({{px, py} = position, _}, x, y) when px == x + 1 and py == y + 1,
      do: {position, "@"}

    defp modify_map(value, _, _), do: value

    defp solve_robots(_, mask, mask, _, _, _), do: 0

    defp solve_robots(positions, owned_mask, target_mask, graph, key_positions, memo) do
      state = {positions, owned_mask}

      case :ets.lookup(memo, state) do
        [{^state, cached_result}] ->
          cached_result

        [] ->
          costs =
            positions
            |> generate_moves(owned_mask, graph, key_positions)
            |> Enum.map(fn {new_positions, key_idx, distance} ->
              key_bit = Bitwise.<<<(1, key_idx)
              new_owned = Bitwise.bor(owned_mask, key_bit)

              new_positions
              |> solve_robots(new_owned, target_mask, graph, key_positions, memo)
              |> Common.add_infinity(distance)
            end)
            |> Enum.reject(&(&1 == :infinity))

          result =
            case costs do
              [] -> :infinity
              costs -> Enum.min(costs)
            end

          :ets.insert(memo, {state, result})
          result
      end
    end

    defp generate_moves({pos1, pos2, pos3, pos4}, owned_mask, graph, key_positions) do
      robot_positions = [pos1, pos2, pos3, pos4]

      robot_positions
      |> Enum.with_index()
      |> Enum.flat_map(fn {robot_pos, robot_idx} ->
        key_positions
        |> Enum.filter(fn {key_idx, _} ->
          key_bit = Bitwise.<<<(1, key_idx)
          Bitwise.band(owned_mask, key_bit) == 0
        end)
        |> Enum.flat_map(fn {_, key_pos} = key_info ->
          graph
          |> Common.get_path(robot_pos, key_pos)
          |> generate_moves({owned_mask, robot_positions, robot_idx, key_info})
        end)
      end)
    end

    defp generate_moves(:unreachable, _), do: []

    defp generate_moves(
           {distance, required_doors},
           {owned_mask, robot_positions, robot_idx, {key_idx, key_pos}}
         ) do
      if Bitwise.band(required_doors, owned_mask) == required_doors do
        new_positions = do_replace(robot_positions, robot_idx, key_pos)

        [{new_positions, key_idx, distance}]
      else
        []
      end
    end

    defp do_replace([_, pos2, pos3, pos4], 0, key), do: {key, pos2, pos3, pos4}
    defp do_replace([pos1, _, pos3, pos4], 1, key), do: {pos1, key, pos3, pos4}
    defp do_replace([pos1, pos2, _, pos4], 2, key), do: {pos1, pos2, key, pos4}
    defp do_replace([pos1, pos2, pos3, _], 3, key), do: {pos1, pos2, pos3, key}
  end
end
