defmodule Aletopelta.Year2021.Day23 do
  @moduledoc """
  Day 23 of Year 2021
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 23
    """

    @type input() :: [binary()]
    @type output() :: [{{integer(), integer()}, type()}]
    @type type() :: binary()

    @spec parse_input(input()) :: output()
    def parse_input(input) do
      [_, _, top_chamber, bottom_chamber | _] = input
      chambers = Enum.join([top_chamber, bottom_chamber])

      amphipods =
        ~r/A|B|C|D/
        |> Regex.scan(chambers)
        |> Enum.flat_map(& &1)

      {top_row, bottom_row} = Enum.split(amphipods, div(length(amphipods), 2))

      x_list =
        2
        |> Range.new(length(top_row) * 2, 2)
        |> Enum.to_list()

      [top_row, bottom_row]
      |> Enum.with_index(1)
      |> Enum.flat_map(&build_subspace(&1, x_list))
    end

    defp build_subspace({[], _}, []), do: []

    defp build_subspace({[amphipod | amphipods], y}, [x | others]) do
      [{{x, y}, amphipod} | build_subspace({amphipods, y}, others)]
    end

    @spec prepare_find(output(), 2 | 4) :: integer()
    def prepare_find(amphipods, home_size) do
      start = %{amphipods: amphipods, home_size: home_size}
      queue = :gb_sets.singleton({0, start})
      visited = MapSet.new()
      distances = %{start.amphipods => 0}

      before_find(queue, visited, distances)
    end

    defp before_find(queue, visited, distances) do
      {{cost, state}, new_queue} = :gb_sets.take_smallest(queue)

      cond do
        MapSet.member?(visited, state.amphipods) -> before_find(new_queue, visited, distances)
        Enum.all?(state.amphipods, &win?/1) -> cost
        true -> find_least(new_queue, visited, distances, cost, state)
      end
    end

    defp win?({{0, _}, _}), do: false
    defp win?({{x, _}, amphipod}), do: home?({x, amphipod})

    defp home?({x, type}), do: home(type) == x

    defp home("A"), do: 2
    defp home("B"), do: 4
    defp home("C"), do: 6
    defp home("D"), do: 8

    defp find_least(queue, visited, distances, cost, state) do
      new_visited = MapSet.put(visited, state.amphipods)

      {new_queue, new_distances} =
        state
        |> get_states()
        |> Enum.reject(&MapSet.member?(visited, &1.state.amphipods))
        |> Enum.reduce({queue, distances}, &reduce_states(&1, cost, &2))

      before_find(new_queue, new_visited, new_distances)
    end

    defp reduce_states(active, cost, {queue, distances}) do
      final_cost = active.cost + cost

      if compare_cost(final_cost, Map.fetch(distances, active.state.amphipods)) == :lower do
        new_distances = Map.put(distances, active.state.amphipods, final_cost)
        new_queue = :gb_sets.add({final_cost, active.state}, queue)

        {new_queue, new_distances}
      else
        {queue, distances}
      end
    end

    defp get_states(state) do
      state.amphipods
      |> Enum.filter(&can_move?(&1, state.amphipods))
      |> Enum.map(&move_hallway(&1, state))
      |> Enum.flat_map(&reach_home/1)
    end

    defp can_move?({{_, 0}, _}, _), do: true

    defp can_move?({{x, y}, _} = amphipod, amphipods) do
      can_move? =
        Enum.any?(amphipods, fn
          {{^x, ny}, _} when y > ny -> true
          _ -> false
        end)

      !can_move? and need_move?(amphipod, amphipods)
    end

    defp need_move?({{x, _}, _}, amphipods) do
      need_move? =
        amphipods
        |> Enum.filter(&(elem(elem(&1, 0), 0) == x))
        |> Enum.all?(&home?({x, elem(&1, 1)}))

      !need_move?
    end

    defp move_hallway({{x, 0}, type} = amphipod, state) do
      target = home(type)

      home? =
        x
        |> get_range(target, :fromhallway)
        |> Enum.reduce_while(false, fn
          nx, false ->
            free? = !Enum.any?(state.amphipods, fn {{x, y}, _} -> x == nx and y == 0 end)

            cond do
              free? and nx == target -> {:halt, true}
              free? -> {:cont, false}
              true -> {:halt, false}
            end
        end)

      {amphipod, state, [], home?}
    end

    defp move_hallway({_, type} = amphipod, state) do
      {list1, home1?} = move_hallway(amphipod, state, -1)
      {list2, home2?} = move_hallway(amphipod, state, 1)

      new_states =
        Enum.map(list1 ++ list2, fn nx ->
          new_cost = get_cost({{nx, 0}, type}, amphipod)

          new_amphipods =
            Enum.map(state.amphipods, fn
              ^amphipod -> {{nx, 0}, type}
              amphipod -> amphipod
            end)

          %{cost: new_cost, state: %{state | amphipods: new_amphipods}}
        end)

      {amphipod, state, new_states, home1? or home2?}
    end

    defp move_hallway({{x, _}, type}, state, delta) do
      (x + delta)
      |> get_range(delta, :fromhome)
      |> Enum.reduce_while({[], false}, &hallway_free(&1, type, state, &2))
    end

    defp get_range(x, -1, :fromhome), do: Range.new(x, 0, -1)
    defp get_range(x, 1, :fromhome), do: Range.new(x, 10, 1)
    defp get_range(x, target, :fromhallway) when x > target, do: Range.new(x - 1, target, -1)
    defp get_range(x, target, :fromhallway), do: Range.new(x + 1, target, 1)

    defp hallway_free(x, type, state, {acc_list, acc_home} = acc) do
      free? = hallway_free?(x, state.amphipods)

      cond do
        free? and x in 2..8//2 -> {:cont, {acc_list, acc_home or home?({x, type})}}
        free? -> {:cont, {[x | acc_list], acc_home}}
        true -> {:halt, acc}
      end
    end

    defp get_cost({{fx, fy}, type}, {{tx, ty}, type}) do
      (abs(fx - tx) + fy + ty) * cost(type)
    end

    defp cost("A"), do: 1
    defp cost("B"), do: 10
    defp cost("C"), do: 100
    defp cost("D"), do: 1000

    defp hallway_free?(x, amphipods) do
      !Enum.any?(amphipods, fn
        {{^x, 0}, _} -> true
        _ -> false
      end)
    end

    defp reach_home({_, _, new_states, false}) do
      new_states
    end

    defp reach_home({{_, type} = amphipod, state, new_states, true}) do
      home_vertical = home(type)

      home_position =
        state.amphipods
        |> Enum.filter(fn {{x, _}, _} -> x == home_vertical end)
        |> next_possibility(state, amphipod)

      if home_position > 0 do
        new_amphipod = {{home_vertical, home_position}, type}
        new_cost = get_cost(new_amphipod, amphipod)

        new_amphipods =
          Enum.map(state.amphipods, fn
            ^amphipod -> new_amphipod
            amphipod -> amphipod
          end)

        [%{cost: new_cost, state: %{state | amphipods: new_amphipods}}]
      else
        new_states
      end
    end

    defp next_possibility(home, state, {_, type}) do
      Enum.reduce_while(state.home_size..1//-1, 0, fn y, _ ->
        placed = Enum.filter(home, fn {{_, ny}, _} -> ny == y end)

        case placed do
          [] -> {:halt, y}
          [{_, ^type}] -> {:cont, 0}
          _ -> {:halt, 0}
        end
      end)
    end

    defp compare_cost(_, :error), do: :lower
    defp compare_cost(n1, {:ok, n2}) when n1 < n2, do: :lower
    defp compare_cost(_, _), do: :notlower
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 23
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.prepare_find(2)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 23
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Enum.flat_map(&upgrade/1)
      |> Common.prepare_find(4)
    end

    defp upgrade({{x, 2}, type}), do: [{{x, 4}, type}]
    defp upgrade({{2 = x, y}, _} = first), do: [first, {{x, y + 1}, "D"}, {{x, y + 2}, "D"}]
    defp upgrade({{4 = x, y}, _} = first), do: [first, {{x, y + 1}, "C"}, {{x, y + 2}, "B"}]
    defp upgrade({{6 = x, y}, _} = first), do: [first, {{x, y + 1}, "B"}, {{x, y + 2}, "A"}]
    defp upgrade({{8 = x, y}, _} = first), do: [first, {{x, y + 1}, "A"}, {{x, y + 2}, "C"}]
  end
end
