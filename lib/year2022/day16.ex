defmodule Aletopelta.Year2022.Day16 do
  @moduledoc """
  Day 16 of Year 2022
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 16
    """
    @spec parse_input(list()) :: map()
    def parse_input(input) do
      Enum.reduce(input, %{}, fn line, map ->
        ~r/[A-Z]{2}|\d+/
        |> Regex.scan(line)
        |> Enum.flat_map(& &1)
        |> then(fn [valve, rate_str | valves] ->
          rate = String.to_integer(rate_str)
          Map.put(map, valve, {rate, valves})
        end)
      end)
    end

    defp get_valves(valve_map, start_valve) do
      valve_map
      |> Enum.filter(fn {valve_id, {flow_rate, _}} ->
        flow_rate > 0 || valve_id == start_valve
      end)
      |> Map.new()
    end

    defp calculate_distances(valve_map, relevant_valves) do
      for {source, _} <- relevant_valves,
          {target, _} <- relevant_valves,
          source != target do
        {{source, target}, get_shortest(valve_map, [source], target)}
      end
      |> then(fn list -> list end)
      |> Map.new()
    end

    defp get_shortest(valve_map, current_valves, target_valve, distance \\ 0) do
      if Enum.member?(current_valves, target_valve) do
        distance
      else
        next_valves =
          current_valves
          |> Enum.map(fn valve -> valve_map[valve] end)
          |> Enum.flat_map(fn {_, connections} -> connections end)
          |> Enum.uniq()

        get_shortest(valve_map, next_valves, target_valve, distance + 1)
      end
    end

    @spec find_path(map(), map(), binary(), number(), number(), number(), any()) :: list()
    def find_path(
          remaining_valves,
          distances,
          current_position,
          time_left,
          current_flow \\ 0,
          pressure \\ 0,
          visited \\ MapSet.new()
        ) do
      if map_size(remaining_valves) == 0 do
        [{time_left * current_flow + pressure, MapSet.new(visited)}]
      else
        current_result = [{time_left * current_flow + pressure, MapSet.new(visited)}]

        next_results =
          remaining_valves
          |> get_next(distances, current_position, time_left, current_flow, pressure, visited)
          |> List.flatten()

        Enum.uniq(current_result ++ next_results)
      end
    end

    defp get_next(
           remaining_valves,
           distances,
           current_position,
           time_left,
           current_flow,
           pressure,
           visited
         ) do
      for {next_valve, {flow_rate, _}} <- remaining_valves,
          travel_time = (distances[{current_position, next_valve}] || 31) + 1,
          travel_time <= time_left do
        updated_visited = MapSet.put(visited, next_valve)
        updated_remaining = Map.delete(remaining_valves, next_valve)
        new_time = time_left - travel_time
        new_pressure = pressure + current_flow * travel_time
        new_flow = current_flow + flow_rate

        find_path(
          updated_remaining,
          distances,
          next_valve,
          new_time,
          new_flow,
          new_pressure,
          updated_visited
        )
      end
    end

    @spec process_input(map(), binary()) :: {map(), map()}
    def process_input(valve_map, start_valve) do
      relevant_valves = get_valves(valve_map, start_valve)
      distances = calculate_distances(valve_map, relevant_valves)

      {relevant_valves, distances}
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 16
    """
    @spec execute(list()) :: number()
    def execute(input) do
      start_valve = "AA"
      time_limit = 30

      {relevant_valves, distances} =
        input
        |> Common.parse_input()
        |> Common.process_input(start_valve)

      relevant_valves
      |> Common.find_path(distances, start_valve, time_limit)
      |> Enum.map(fn {pressure, _} -> pressure end)
      |> Enum.max()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 16
    """
    @spec execute(list()) :: number()
    def execute(input) do
      start_valve = "AA"
      time_limit = 26

      {relevant_valves, distances} =
        input
        |> Common.parse_input()
        |> Common.process_input(start_valve)

      all_paths =
        relevant_valves
        |> Map.delete(start_valve)
        |> Common.find_path(distances, start_valve, time_limit)
        |> Enum.group_by(
          fn {_, path} -> path end,
          fn {pressure, _} -> pressure end
        )
        |> Enum.map(fn {path, pressures} -> {path, Enum.max(pressures)} end)

      find_pair(all_paths)
    end

    defp find_pair(paths) do
      paths
      |> Enum.map(fn {my_path, my_pressure} ->
        elephant_candidates =
          paths
          |> Enum.filter(fn {elephant_path, _} ->
            MapSet.disjoint?(my_path, elephant_path)
          end)
          |> Enum.map(fn {_, pressure} -> pressure end)

        if Enum.empty?(elephant_candidates) do
          my_pressure
        else
          my_pressure + Enum.max(elephant_candidates)
        end
      end)
      |> Enum.max()
    end
  end
end
