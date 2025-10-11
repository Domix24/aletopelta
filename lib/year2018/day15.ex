defmodule Aletopelta.Year2018.Day15 do
  @moduledoc """
  Day 15 of Year 2018
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 15
    """

    @type input() :: list(binary())
    @type position() :: {integer(), integer()}
    @type output() :: {[{position(), element()}], [{position(), nil | team()}]}
    @type element() :: nil | :open
    @type team() :: :elf | :goblin
    @type unit() :: %{
            position: position(),
            id: integer(),
            attack_power: integer(),
            type: team(),
            hit_points: integer()
          }
    @type board() :: %{
            elements: %{position() => element()},
            units: %{position() => unit()},
            next_units: [unit()],
            round: integer()
          }

    @spec parse_input(input()) :: output()
    def parse_input(input) do
      input
      |> Stream.with_index()
      |> Stream.flat_map(fn {line, y} ->
        line
        |> String.graphemes()
        |> Stream.with_index()
        |> Stream.map(&{&1, y})
      end)
      |> Stream.map(fn {{symbol, x}, y} -> parse_symbol(symbol, {y, x}) end)
      |> Enum.unzip()
      |> remove_empty()
    end

    defp remove_empty({elements, units}), do: {elements, remove_empty(units)}
    defp remove_empty(units), do: Enum.reject(units, &remove_empty(&1, :remove))
    defp remove_empty({_, nil}, :remove), do: true
    defp remove_empty(_, :remove), do: false

    defp parse_symbol(symbol, position),
      do: {{position, element(symbol)}, {position, unit(symbol)}}

    defp element("#"), do: nil
    defp element(_), do: :open

    defp unit("E"), do: :elf
    defp unit("G"), do: :goblin
    defp unit(_), do: nil

    @spec score(board()) :: integer()
    def score(board), do: rounds(board) * units_score(board)

    defp rounds(%{next_units: [], round: round}), do: round
    defp rounds(%{round: round}), do: round - 1

    defp units_score(%{units: units}), do: Enum.sum_by(units, &elem(&1, 1).hit_points)

    @spec play(%{elf: integer(), goblin: integer()}, output()) :: board()
    def play(powers, parsed),
      do:
        powers
        |> states(parsed)
        |> Enum.at(-1)

    defp states(powers, parsed) do
      {elements, units} = parsed

      elements
      |> create_board(units, powers)
      |> Stream.iterate(&next_play/1)
      |> Stream.take_while(&(&1 != :over))
    end

    defp create_board(elements, units, powers),
      do: %{
        elements: Map.new(elements),
        units: build_units(units, powers),
        next_units: [],
        round: 0
      }

    defp build_units(units, powers),
      do:
        units
        |> Stream.with_index()
        |> Map.new(fn {{position, type}, id} ->
          {position, create_unit(id, type, position, powers)}
        end)

    defp create_unit(id, type, position, attack_powers),
      do: %{
        id: id,
        type: type,
        position: position,
        hit_points: 200,
        attack_power: Map.fetch!(attack_powers, type)
      }

    defp next_play(%{units: units} = board) do
      one_team? =
        units
        |> Stream.map(fn {_, %{type: type}} -> type end)
        |> all_same?()

      if one_team? do
        :over
      else
        %{next_units: [unit | next_units]} = new_board = order_units(board)

        new_board
        |> Map.put(:next_units, next_units)
        |> play_unit(unit)
      end
    end

    defp order_units(%{next_units: [], units: units, round: round} = board) do
      next =
        units
        |> Enum.map(&elem(&1, 1))
        |> Enum.sort_by(& &1.position)

      board
      |> Map.put(:next_units, next)
      |> Map.put(:round, round + 1)
    end

    defp order_units(board), do: board

    defp all_same?(list),
      do:
        list
        |> Enum.reduce_while({0, nil}, fn
          value, {0, nil} -> {:cont, {1, value}}
          value, {1, value} = acc -> {:cont, acc}
          _, _ -> {:halt, false}
        end)
        |> all_same?(:two)

    defp all_same?(false, :two), do: false
    defp all_same?(_, :two), do: true

    defp play_unit(board, unit) do
      case next_move(unit, board) do
        nil -> board
        {:move, position} -> move_unit(board, unit, position)
        :attack -> attack(board, unit)
      end
    end

    defp move_unit(board, %{position: previous} = unit, position) do
      new_unit = move(unit, position)

      board
      |> Map.update!(:units, fn old ->
        old
        |> Map.delete(previous)
        |> Map.put(position, new_unit)
      end)
      |> attack(new_unit)
    end

    defp attack(board, unit) do
      case find_enemy(unit, board) do
        nil ->
          board

        enemy ->
          new_enemy = attack_enemy(enemy, unit)
          new_board = update_next(board, new_enemy)

          if dead?(new_enemy) do
            remove(new_board, new_enemy)
          else
            update_units(new_board, new_enemy)
          end
      end
    end

    defp update_next(%{next_units: units} = board, %{id: id} = enemy) do
      next_units =
        Enum.map(units, fn
          %{id: ^id} -> enemy
          next -> next
        end)

      Map.put(board, :next_units, next_units)
    end

    defp update_units(board, %{position: position} = enemy),
      do:
        Map.update!(board, :units, fn units ->
          Map.put(units, position, enemy)
        end)

    defp remove(board, %{position: position, id: id}),
      do:
        board
        |> Map.update!(:units, &Map.delete(&1, position))
        |> Map.update!(:next_units, &Enum.reject(&1, fn %{id: nid} -> nid === id end))

    defp move(unit, position), do: Map.put(unit, :position, position)

    defp attack_enemy(unit, %{attack_power: power}),
      do: Map.update!(unit, :hit_points, &max(&1 - power, 0))

    defp dead?(%{hit_points: points}), do: points === 0

    defp find_enemy(%{position: position} = unit, board),
      do:
        position
        |> adjacent()
        |> Stream.map(&at(board, &1))
        |> Stream.filter(&enemies?(unit, &1))
        |> Enum.min_by(&{&1.hit_points, &1.position}, fn -> nil end)

    defp next_move(unit, board) do
      case shortest(unit, board) do
        [] ->
          nil

        paths ->
          one_step? =
            Enum.any?(paths, fn
              [_, _] -> true
              _ -> false
            end)

          if one_step? do
            :attack
          else
            extract_position(paths)
          end
      end
    end

    defp extract_position(paths) do
      [_, target | _] = Enum.min_by(paths, fn [_, position | _] -> position end)

      [_, next_position | _] =
        paths
        |> Enum.find(fn [_, possible_target | _] -> possible_target == target end)
        |> Enum.reverse()

      {:move, next_position}
    end

    defp shortest(unit, board) do
      {MapSet.new([unit.position]), [[unit.position]]}
      |> Stream.iterate(fn {visited, paths} -> expand(unit, board, visited, paths) end)
      |> Stream.map(fn {_, paths} -> paths end)
      |> Enum.find_value(nil, fn
        [] ->
          []

        paths ->
          case Enum.filter(paths, &enemies?(unit, at(board, hd(&1)))) do
            [] -> nil
            paths -> paths
          end
      end)
    end

    defp expand(unit, board, visited, paths) do
      {visited, paths} =
        Enum.reduce(
          paths,
          {visited, []},
          fn path, {visited, paths} ->
            case next_path(unit, board, visited, path) do
              [] ->
                {visited, paths}

              next_path_positions ->
                paths = Enum.reduce(next_path_positions, paths, &[[&1 | path] | &2])
                visited = MapSet.union(visited, MapSet.new(next_path_positions))
                {visited, paths}
            end
          end
        )

      {visited, Enum.reverse(paths)}
    end

    defp next_path(unit, board, visited, [path | _]),
      do:
        path
        |> adjacent()
        |> Stream.filter(&valid_position?/1)
        |> Stream.reject(&MapSet.member?(visited, &1))
        |> Enum.filter(&valid?(&1, unit, board))

    defp adjacent({y, x}), do: [{y - 1, x}, {y, x - 1}, {y, x + 1}, {y + 1, x}]
    defp valid_position?({y, x}), do: y > -1 and x > -1

    defp valid?(position, unit, board) do
      case at(board, position) do
        :open -> true
        cell -> enemies?(unit, cell)
      end
    end

    defp enemies?(%{type: type1}, %{type: type2}) when type1 != type2, do: true
    defp enemies?(_, _), do: false

    defp at(%{units: units, elements: elements}, position) do
      case Map.fetch(units, position) do
        :error -> Map.fetch!(elements, position)
        {:ok, value} -> value
      end
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
      |> do_part()
    end

    defp do_part(parsed),
      do:
        %{elf: 3, goblin: 3}
        |> Common.play(parsed)
        |> Common.score()
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 15
    """

    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> do_part()
    end

    defp do_part(parsed) do
      num_elves = count_units(:elf, parsed)

      20
      |> Stream.iterate(&(&1 + 1))
      |> Stream.map(&Common.play(%{elf: &1, goblin: 3}, parsed))
      |> Enum.find(&(winner?(&1, :elf) && count_units(&1) == num_elves))
      |> Common.score()
    end

    defp count_units(type, {_, units}), do: Enum.count(units, fn {_, utype} -> utype === type end)
    defp count_units(%{units: units}), do: map_size(units)

    defp winner?(%{units: units}, type) do
      [{_, %{type: winner}}] = Enum.uniq_by(units, fn {_, %{type: type}} -> type end)

      winner === type
    end
  end
end
