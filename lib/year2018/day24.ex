defmodule Aletopelta.Year2018.Day24 do
  @moduledoc """
  Day 24 of Year 2018
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 24
    """

    @type input() :: list(binary())
    @type group() :: %{
            index: integer(),
            units: integer(),
            hp: integer(),
            damage: integer(),
            style: atom(),
            initiative: integer(),
            group: atom(),
            target: integer(),
            touched: integer(),
            immune: [atom()],
            weak: [atom()]
          }
    @type groups() :: %{integer() => group()}
    @type system() :: %{immune: groups(), infection: groups()}

    @spec parse_input(input()) :: system()
    def parse_input(input) do
      input
      |> Enum.chunk_by(&String.contains?(&1, ":"))
      |> Enum.chunk_every(2)
      |> Map.new(fn [[style], lines] ->
        groups =
          lines
          |> Enum.reject(&(&1 === ""))
          |> Enum.with_index(&parse_line/2)
          |> Map.new(&{&1.index, &1})

        {parse_style(style), groups}
      end)
    end

    defp parse_line(line, index) do
      [[_, nbunits_str, hp_str, special, damageforce_str, damage, initiative_str]] =
        Regex.scan(~r"(\d+)\D+(\d+)[^\(\d]+\(?([^\)\d]*)\)?\D+(\d+) (\w+)\D+(\d+)", line)

      [nbunits, hp, damageforce, initiative] =
        Enum.map([nbunits_str, hp_str, damageforce_str, initiative_str], &String.to_integer/1)

      parse_special(
        %{
          index: index,
          units: nbunits,
          hp: hp,
          damage: damageforce,
          style: one_atom(damage),
          initiative: initiative,
          group: nil,
          target: nil,
          touched: 0
        },
        special
      )
    end

    defp parse_special(initial, special),
      do:
        ~r"\w+"
        |> Regex.scan(special)
        |> Enum.flat_map(& &1)
        |> Enum.reject(&(&1 in ["to"]))
        |> Enum.chunk_by(&(&1 in ["immune", "weak"]))
        |> Enum.chunk_every(2)
        |> Map.new(fn [[protect], specials] ->
          {one_atom(protect), special_atoms(specials)}
        end)
        |> Map.merge(initial)

    defp special_atoms(specials), do: Enum.map(specials, &one_atom/1)

    defp parse_style(style),
      do:
        ~r"\w+"
        |> Regex.scan(style)
        |> Enum.at(0)
        |> Enum.at(0)
        |> String.downcase()
        |> one_atom()

    defp one_atom(atom), do: Enum.at(~w"#{atom}"a, 0)

    defp one_group(%{infection: infection, immune: immune}) when map_size(infection) === 0,
      do: immune

    defp one_group(%{infection: infection, immune: immune}) when map_size(immune) === 0,
      do: infection

    defp one_group(_), do: nil

    defp inner_battle(groups),
      do:
        groups
        |> target()
        |> attack()

    @spec battle(system()) :: groups()
    def battle(groups),
      do:
        groups
        |> inner_battle()
        |> Stream.iterate(&inner_battle/1)
        |> Enum.find_value(&finish/1)

    defp finish(groups) do
      one_group = one_group(groups)

      if is_nil(one_group) do
        all_nil? =
          groups
          |> Map.values()
          |> Enum.flat_map(&Map.values/1)
          |> Enum.all?(&(&1.touched < 1))

        if all_nil? do
          %{0 => %{group: :none}}
        else
          nil
        end
      else
        one_group
      end
    end

    defp target(groups),
      do:
        Map.new(groups, fn {group, units} ->
          opposing = groups[oppose(group)]

          {_, new_units} =
            units
            |> Enum.sort_by(&{effective(elem(&1, 1)), elem(&1, 1).initiative}, :desc)
            |> Enum.reduce({MapSet.new(), Map.new()}, &reduce_units(&1, &2, opposing, group))

          {group, new_units}
        end)

    defp reduce_units({_, unit}, {attacked, _} = accumulator, opposing, group),
      do:
        opposing
        |> Enum.reject(&MapSet.member?(attacked, elem(&1, 0)))
        |> Enum.group_by(&damage(elem(&1, 1), unit))
        |> Enum.reject(&(elem(&1, 0) < 1))
        |> handle_grouped(unit, group, accumulator)

    defp handle_grouped([], unit, group, {attacked, units}) do
      new_unit = %{unit | target: nil, group: group, touched: 0}

      new_units = Map.put(units, new_unit.index, new_unit)

      {attacked, new_units}
    end

    defp handle_grouped(grouped, unit, group, {attacked, units}) do
      target =
        grouped
        |> Enum.max_by(&elem(&1, 0))
        |> elem(1)
        |> Enum.max_by(&effective(elem(&1, 1)))
        |> elem(1)

      new_unit = %{unit | target: target.index, group: group, touched: 0}

      new_units = Map.put(units, new_unit.index, new_unit)
      new_attacked = MapSet.put(attacked, target.index)

      {new_attacked, new_units}
    end

    defp damage(enemy, unit) do
      cond do
        immune?(enemy, unit) -> 0
        weak?(enemy, unit) -> effective(unit) * 2
        true -> effective(unit)
      end
    end

    defp attack(groups),
      do:
        groups
        |> Enum.flat_map(fn {_, group} ->
          Enum.map(group, &elem(&1, 1))
        end)
        |> Enum.sort_by(& &1.initiative, :desc)
        |> Enum.reduce(groups, fn old_unit, groups ->
          process_unit(groups[old_unit.group][old_unit.index], groups)
        end)

    defp process_unit(nil, groups), do: groups

    defp process_unit(unit, groups),
      do: process_target(groups[oppose(unit.group)][unit.target], groups, unit)

    defp process_target(nil, groups, _), do: groups

    defp process_target(old_enemy, groups, unit) do
      touched_enemy = div(damage(old_enemy, unit), old_enemy.hp)
      enemy = %{old_enemy | units: old_enemy.units - touched_enemy}

      groups
      |> Map.update!(unit.group, fn acc_group ->
        Map.update!(acc_group, unit.index, &%{&1 | touched: touched_enemy})
      end)
      |> update_target(enemy, unit)
    end

    defp update_target(groups, enemy, unit) when enemy.units < 1,
      do:
        Map.update!(groups, oppose(unit.group), fn group ->
          Map.delete(group, enemy.index)
        end)

    defp update_target(groups, enemy, unit),
      do:
        Map.update!(groups, oppose(unit.group), fn group ->
          Map.update!(group, enemy.index, fn _ -> enemy end)
        end)

    defp effective(unit), do: unit.units * unit.damage

    defp oppose(:immune), do: :infection
    defp oppose(:infection), do: :immune

    defp immune?(unit1, unit2),
      do:
        unit1
        |> Map.get(:immune, [])
        |> Enum.member?(unit2.style)

    defp weak?(unit1, unit2),
      do:
        unit1
        |> Map.get(:weak, [])
        |> Enum.member?(unit2.style)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 24
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.battle()
      |> Enum.sum_by(&elem(&1, 1).units)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 24
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> do_loop()
    end

    defp do_loop(groups),
      do:
        %{groups: groups, winner: nil, units: nil}
        |> boost(30)
        |> Stream.iterate(&boost(&1))
        |> Enum.find(&(&1.winner === :immune))
        |> Map.fetch!(:units)
        |> Enum.sum_by(&elem(&1, 1).units)

    defp boost(state, kick \\ 1) do
      boosted =
        Map.update!(state.groups, :immune, fn group ->
          Map.new(group, fn {index, unit} ->
            {index, %{unit | damage: unit.damage + kick}}
          end)
        end)

      winner = Common.battle(boosted)
      group = Enum.find_value(winner, fn {_, unit} -> unit.group end)

      %{state | groups: boosted, winner: group, units: winner}
    end
  end
end
