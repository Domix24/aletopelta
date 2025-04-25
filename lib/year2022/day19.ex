defmodule Aletopelta.Year2022.Day19 do
  @moduledoc """
  Day 19 of Year 2022
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 19
    """
    @spec parse_input(list(binary())) :: list(any())
    def parse_input(input) do
      Enum.map(input, fn line ->
        [id, ore_cost, clay_cost, obs_ore, obs_clay, geo_ore, geo_obs] =
          ~r/\d+/
          |> Regex.scan(line)
          |> Enum.map(fn [value] -> String.to_integer(value) end)

        {id, ore_cost, clay_cost, {obs_ore, obs_clay}, {geo_ore, geo_obs}}
      end)
    end

    @spec solve_blueprint(
            {integer(), integer(), integer(), {integer(), integer()}, {integer(), integer()}},
            integer()
          ) :: {integer(), integer()}
    def solve_blueprint(
          {id, ore_cost, clay_cost, {obs_ore, obs_clay}, {geo_ore, geo_obs}} = blueprint,
          time_limit
        ) do
      max_ore = Enum.max([ore_cost, clay_cost, obs_ore, geo_ore])
      max_clay = obs_clay
      max_obs = geo_obs

      start_state = {
        0,
        0,
        0,
        0,
        1,
        0,
        0,
        0,
        time_limit
      }

      table_name = :ets.new(:memo_cache, [:set])

      try do
        {max_geo, _} =
          search(
            start_state,
            blueprint,
            {max_ore, max_clay, max_obs},
            table_name
          )

        {id * max_geo, max_geo}
      after
        :ets.delete(table_name)
      end
    end

    defp enough_resources?(count, rate, remaining_time, max_needed) do
      count >= max_needed * remaining_time - rate * (remaining_time - 1)
    end

    defp search({_, _, _, geo, _, _, _, _, 0}, _, _, table) do
      {geo, table}
    end

    defp search({_, _, _, geo, _, _, _, geo_bots, time} = state, blueprint, limits, table) do
      case :ets.lookup(table, state) do
        [{_, cached_result}] ->
          {cached_result, table}

        [] ->
          max_possible = geo + geo_bots * time + div(time * (time - 1), 2)

          best_so_far =
            case :ets.lookup(table, :best) do
              [{_, {val, _}}] -> val
              [] -> 0
            end

          if max_possible <= best_so_far do
            {0, table}
          else
            get_best(state, blueprint, limits, table)
          end
      end
    end

    defp get_best(state, blueprint, limits, table) do
      {best_geo, _} =
        []
        |> Enum.concat(move_geode(state, blueprint, limits))
        |> Enum.concat(move_obsidian(state, blueprint, limits))
        |> Enum.concat(move_clay(state, blueprint, limits))
        |> Enum.concat(move_ore(state, blueprint, limits))
        |> move_final(state, blueprint, limits)
        |> best_geode(blueprint, limits, table)

      :ets.insert(table, {state, best_geo})
      {best_geo, table}
    end

    defp move_geode(
           {ore, _, obs, _, _, _, _, _, _} = state,
           {_, _, _, _, {geo_ore, geo_obs} = geo},
           _
         )
         when ore >= geo_ore and obs >= geo_obs do
      update_geode(state, geo, 1)
    end

    defp move_geode(
           {ore, _, obs, _, ore_bots, _, obs_bots, _, time} = state,
           {_, _, _, _, {geo_ore, geo_obs}} = blueprint,
           _
         )
         when obs_bots > 0 do
      ore_wait = if ore_bots == 0, do: time, else: max(0, ceil((geo_ore - ore) / ore_bots))
      obs_wait = max(0, ceil((geo_obs - obs) / obs_bots))
      geo_wait = max(ore_wait, obs_wait) + 1
      wait_geode(state, blueprint, geo_wait)
    end

    defp move_geode(_, _, _), do: []

    defp wait_geode({_, _, _, _, _, _, _, _, time} = state, {_, _, _, _, geo}, wait)
         when wait < time do
      update_geode(state, geo, wait)
    end

    defp wait_geode(_, _, _), do: []

    defp update_state(state, type, wait \\ 1, mod \\ 0)

    defp update_state(
           {ore, clay, obs, geo, ore_bots, clay_bots, obs_bots, geo_bots, time},
           :ore,
           wait,
           mod
         ) do
      {ore + ore_bots * wait - mod, clay, obs, geo, ore_bots, clay_bots, obs_bots, geo_bots, time}
    end

    defp update_state(
           {ore, clay, obs, geo, ore_bots, clay_bots, obs_bots, geo_bots, time},
           :clay,
           wait,
           mod
         ) do
      {ore, clay + clay_bots * wait - mod, obs, geo, ore_bots, clay_bots, obs_bots, geo_bots,
       time}
    end

    defp update_state(
           {ore, clay, obs, geo, ore_bots, clay_bots, obs_bots, geo_bots, time},
           :obs,
           wait,
           mod
         ) do
      {ore, clay, obs + obs_bots * wait - mod, geo, ore_bots, clay_bots, obs_bots, geo_bots, time}
    end

    defp update_state(
           {ore, clay, obs, geo, ore_bots, clay_bots, obs_bots, geo_bots, time},
           :geo,
           wait,
           mod
         ) do
      {ore, clay, obs, geo + geo_bots * wait - mod, ore_bots, clay_bots, obs_bots, geo_bots, time}
    end

    defp update_state(
           {ore, clay, obs, geo, ore_bots, clay_bots, obs_bots, geo_bots, time},
           :orebot,
           mod,
           _
         ) do
      {ore, clay, obs, geo, ore_bots + mod, clay_bots, obs_bots, geo_bots, time}
    end

    defp update_state(
           {ore, clay, obs, geo, ore_bots, clay_bots, obs_bots, geo_bots, time},
           :claybot,
           mod,
           _
         ) do
      {ore, clay, obs, geo, ore_bots, clay_bots + mod, obs_bots, geo_bots, time}
    end

    defp update_state(
           {ore, clay, obs, geo, ore_bots, clay_bots, obs_bots, geo_bots, time},
           :obsbot,
           mod,
           _
         ) do
      {ore, clay, obs, geo, ore_bots, clay_bots, obs_bots + mod, geo_bots, time}
    end

    defp update_state(
           {ore, clay, obs, geo, ore_bots, clay_bots, obs_bots, geo_bots, time},
           :geobot,
           mod,
           _
         ) do
      {ore, clay, obs, geo, ore_bots, clay_bots, obs_bots, geo_bots + mod, time}
    end

    defp update_state(
           {ore, clay, obs, geo, ore_bots, clay_bots, obs_bots, geo_bots, _},
           :time,
           0,
           _
         ) do
      {ore, clay, obs, geo, ore_bots, clay_bots, obs_bots, geo_bots, 0}
    end

    defp update_state(
           {ore, clay, obs, geo, ore_bots, clay_bots, obs_bots, geo_bots, time},
           :time,
           wait,
           _
         ) do
      {ore, clay, obs, geo, ore_bots, clay_bots, obs_bots, geo_bots, time - wait}
    end

    defp update_geode(state, {geo_ore, geo_obs}, wait) do
      state
      |> update_state(:ore, wait, geo_ore)
      |> update_state(:clay, wait)
      |> update_state(:obs, wait, geo_obs)
      |> update_state(:geo, wait)
      |> update_state(:time, wait)
      |> update_state(:geobot)
      |> then(&[&1])
    end

    defp move_obsidian(state, blueprint, limits, additionnal \\ :initial)

    defp move_obsidian(
           {ore, clay, obs, _, ore_bots, clay_bots, obs_bots, _, time} = state,
           {_, _, _, {obs_ore, obs_clay}, {_, geo_obs}} = blueprint,
           {_, _, max_obs} = limits,
           :initial
         )
         when obs_bots < max_obs and clay_bots > 0 do
      if enough_resources?(obs, obs_bots, time, geo_obs) do
        []
      else
        ore_wait = if ore_bots == 0, do: time, else: max(0, ceil((obs_ore - ore) / ore_bots))
        clay_wait = max(0, ceil((obs_clay - clay) / clay_bots))
        obs_wait = max(ore_wait, clay_wait) + 1

        move_obsidian(state, blueprint, limits, {:wait, obs_wait})
      end
    end

    defp move_obsidian(
           {_, _, _, _, _, _, _, _, time} = state,
           {_, _, _, {obs_ore, obs_clay}, _},
           _,
           {:wait, wait}
         )
         when wait < time do
      state
      |> update_state(:ore, wait, obs_ore)
      |> update_state(:clay, wait, obs_clay)
      |> update_state(:obs, wait)
      |> update_state(:geo, wait)
      |> update_state(:time, wait)
      |> update_state(:obsbot)
      |> then(&[&1])
    end

    defp move_obsidian(_, _, _, _), do: []

    defp move_clay(state, blueprint, limits, additionnal \\ :initial)

    defp move_clay(
           {ore, clay, _, _, ore_bots, clay_bots, _, _, time} = state,
           {_, _, clay_cost, {_, obs_clay}, _} = blueprint,
           {_, max_clay, _} = limits,
           :initial
         )
         when clay_bots < max_clay do
      if enough_resources?(clay, clay_bots, time, obs_clay) do
        []
      else
        ore_wait = if ore_bots == 0, do: time, else: max(0, ceil((clay_cost - ore) / ore_bots))
        clay_wait = ore_wait + 1

        move_clay(state, blueprint, limits, {:wait, clay_wait})
      end
    end

    defp move_clay(
           {_, _, _, _, _, _, _, _, time} = state,
           {_, _, clay_cost, _, _},
           _,
           {:wait, wait}
         )
         when wait < time - 2 do
      state
      |> update_state(:ore, wait, clay_cost)
      |> update_state(:clay, wait)
      |> update_state(:obs, wait)
      |> update_state(:geo, wait)
      |> update_state(:time, wait)
      |> update_state(:claybot)
      |> then(&[&1])
    end

    defp move_clay(_, _, _, _), do: []

    defp move_ore(state, blueprint, limits, additionnal \\ :initial)

    defp move_ore(
           {ore, _, _, _, ore_bots, _, _, _, time} = state,
           {_, ore_cost, clay_cost, {obs_ore, _}, {geo_ore, _}} = blueprint,
           {max_ore, _, _} = limits,
           :initial
         )
         when ore_bots < max_ore do
      if enough_resources?(ore, ore_bots, time, Enum.max([ore_cost, clay_cost, obs_ore, geo_ore])) do
        []
      else
        ore_wait = if ore_bots == 0, do: time, else: max(0, ceil((ore_cost - ore) / ore_bots))
        wait_time = ore_wait + 1

        move_ore(state, blueprint, limits, {:wait, wait_time})
      end
    end

    defp move_ore(
           {_, _, _, _, _, _, _, _, time} = state,
           {_, ore_cost, _, _, _},
           _,
           {:wait, wait}
         )
         when wait < time - 3 do
      state
      |> update_state(:ore, wait, ore_cost)
      |> update_state(:clay, wait)
      |> update_state(:obs, wait)
      |> update_state(:geo, wait)
      |> update_state(:time, wait)
      |> update_state(:orebot)
      |> then(&[&1])
    end

    defp move_ore(_, _, _, _), do: []

    defp move_final([], {_, _, _, _, _, _, _, _, time} = state, _, _) do
      state
      |> update_state(:ore, time)
      |> update_state(:clay, time)
      |> update_state(:obs, time)
      |> update_state(:geo, time)
      |> update_state(:time, 0)
      |> then(&[&1])
    end

    defp move_final(moves, _, _, _), do: moves

    defp best_geode(next_moves, blueprint, limits, table) do
      Enum.reduce(next_moves, {0, table}, fn next_state, {best, curr_table} ->
        {result, updated_table} = search(next_state, blueprint, limits, curr_table)

        if result > best do
          :ets.insert(updated_table, {:best, {result, next_state}})
          {result, updated_table}
        else
          {best, updated_table}
        end
      end)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 19
    """
    @spec execute(list(binary())) :: integer()
    def execute(input) do
      input
      |> Common.parse_input()
      |> Enum.sum_by(fn blueprint ->
        blueprint
        |> Common.solve_blueprint(24)
        |> elem(0)
      end)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 19
    """
    @spec execute(list(binary())) :: integer()
    def execute(input) do
      input
      |> Common.parse_input()
      |> Enum.take(3)
      |> Task.async_stream(fn blueprint ->
        blueprint
        |> Common.solve_blueprint(32)
        |> elem(1)
      end)
      |> Enum.reduce(1, fn {:ok, result}, acc -> acc * result end)
    end
  end
end
