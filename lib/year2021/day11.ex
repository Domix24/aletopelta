defmodule Aletopelta.Year2021.Day11 do
  @moduledoc """
  Day 11 of Year 2021
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 11
    """
    @type point() :: {integer(), integer()}
    @type octopus() :: %{point() => integer()}

    @spec parse_input([binary()]) :: octopus()
    def parse_input(input) do
      {_, result} =
        Enum.reduce(input, {0, %{}}, fn line, {y, acc} ->
          new_acc = parse_line(line, acc, 0, y)
          {y + 1, new_acc}
        end)

      result
    end

    defp parse_line("", map, _, _), do: map

    defp parse_line(<<sign, rest::binary>>, map, x, y) do
      number = String.to_integer(<<sign>>)
      new_map = Map.put(map, {x, y}, number)
      parse_line(rest, new_map, x + 1, y)
    end

    defp increment_energy(octopus_map) do
      Enum.reduce(octopus_map, {%{}, [], 0}, fn
        {grid_pos, 9}, {map_acc, flash_acc, count_acc} ->
          {Map.put(map_acc, grid_pos, 0), [grid_pos | flash_acc], count_acc + 1}

        {grid_pos, energy_level}, {map_acc, flash_acc, count_acc} ->
          {Map.put(map_acc, grid_pos, energy_level + 1), flash_acc, count_acc}
      end)
    end

    defp find_neighbors({pos_x, pos_y}, octopus_map) do
      Enum.flat_map(
        [{-1, -1}, {0, -1}, {1, -1}, {-1, 0}, {1, 0}, {-1, 1}, {0, 1}, {1, 1}],
        fn {delta_x, delta_y} ->
          neighbor_pos = {delta_x + pos_x, delta_y + pos_y}

          case Map.fetch(octopus_map, neighbor_pos) do
            {:ok, _} -> [neighbor_pos]
            _ -> []
          end
        end
      )
    end

    defp process_neighbor(neighbor_pos, {map_acc, flashed_acc, count_acc} = acc) do
      case Map.fetch!(map_acc, neighbor_pos) do
        9 ->
          {Map.put(map_acc, neighbor_pos, 0), MapSet.put(flashed_acc, neighbor_pos),
           count_acc + 1}

        0 ->
          if MapSet.member?(flashed_acc, neighbor_pos) do
            acc
          else
            {Map.put(map_acc, neighbor_pos, 1), flashed_acc, count_acc}
          end

        energy_level ->
          {Map.put(map_acc, neighbor_pos, energy_level + 1), flashed_acc, count_acc}
      end
    end

    @spec simulate_rounds(octopus(), {integer(), integer()}, [point()], MapSet.t(point())) ::
            {integer(), octopus()}
    def simulate_rounds(octopus_map, {max_rounds, max_rounds}, [], _), do: {0, octopus_map}

    def simulate_rounds(octopus_map, {current_round, max_rounds}, [], _) do
      {updated_map, initial_queue, initial_flashes} = increment_energy(octopus_map)
      initial_flashed = MapSet.new(initial_queue)

      {round_flashes, final_map} =
        simulate_rounds(
          updated_map,
          {current_round + 1, max_rounds},
          initial_queue,
          initial_flashed
        )

      {initial_flashes + round_flashes, final_map}
    end

    def simulate_rounds(octopus_map, round_progress, [_ | _] = flash_queue, flashed_set) do
      {updated_map, new_flashed, flash_count} =
        flash_queue
        |> Enum.flat_map(fn flash_pos ->
          flash_pos
          |> find_neighbors(octopus_map)
          |> Enum.reject(&MapSet.member?(flashed_set, &1))
        end)
        |> Enum.reduce({octopus_map, MapSet.new(), 0}, &process_neighbor/2)

      next_queue = MapSet.to_list(new_flashed)
      combined_flashed = MapSet.union(flashed_set, new_flashed)

      {new_count, new_map} =
        simulate_rounds(updated_map, round_progress, next_queue, combined_flashed)

      {flash_count + new_count, new_map}
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 11
    """
    @spec execute([binary()], []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> simulate_rounds()
    end

    defp simulate_rounds(octopus_map) do
      {total_flashes, _} = Common.simulate_rounds(octopus_map, {0, 100}, [], MapSet.new())
      total_flashes
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 11
    """
    @spec execute([binary()], []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> find_sync(0)
    end

    defp find_sync(octopus_map, step_count) do
      next_step = step_count + 1

      {total_flashes, final_map} =
        Common.simulate_rounds(octopus_map, {step_count, next_step}, [], MapSet.new())

      if total_flashes == 100 do
        next_step
      else
        find_sync(final_map, next_step)
      end
    end
  end
end
