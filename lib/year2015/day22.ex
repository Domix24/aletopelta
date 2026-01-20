defmodule Aletopelta.Year2015.Day22 do
  @moduledoc """
  Day 22 of Year 2015
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 22
    """

    @type input() :: list(binary())
    @type output() :: integer()

    defmodule Wizard do
      @type t() :: %__MODULE__{hitpoints: integer(), mana: integer(), armor: 0}

      defstruct [:hitpoints, :mana, armor: 0]

      @spec new(integer(), integer()) :: t()
      def new(hitpoints, mana), do: %__MODULE__{hitpoints: hitpoints, mana: mana}
    end

    defmodule Boss do
      @type t() :: %__MODULE__{hitpoints: integer(), damage: integer()}

      defstruct [:hitpoints, :damage]

      @spec new(integer(), integer()) :: t()
      def new(hitpoints, damage), do: %__MODULE__{hitpoints: hitpoints, damage: damage}
    end

    defmodule Spell do
      @type t() :: %__MODULE__{
              cost: integer(),
              effect: nil | atom(),
              duration: integer(),
              damage: integer(),
              heal: integer()
            }

      defstruct [:cost, :effect, :duration, damage: 0, heal: 0]

      @spec new(integer(), list({:effect, atom()} | {:duration | :damage | :heal, integer()})) ::
              t()
      def new(cost, list),
        do:
          list
          |> Enum.reduce(%__MODULE__{}, fn {key, value}, acc ->
            Map.update!(acc, key, fn _ -> value end)
          end)
          |> new(cost, :internal)

      defp new(%__MODULE__{} = map, cost, :internal), do: %__MODULE__{map | cost: cost}
    end

    defmodule Effect do
      @type t() :: %__MODULE__{
              armor: nil | integer(),
              damage: nil | integer(),
              mana: nil | integer()
            }

      defstruct [:armor, :damage, :mana]

      @spec new(list({:armor | :damage | :mana, integer()})) :: t()
      def new(list),
        do:
          Enum.reduce(list, %__MODULE__{}, fn {key, value}, acc ->
            Map.update!(acc, key, fn _ -> value end)
          end)
    end

    @spec parse_input(input()) :: Boss.t()
    def parse_input(input) do
      input
      |> Enum.map(fn line ->
        [_, sname, svalue] =
          ~r"([a-z ]+).*\b(\d+)"
          |> Regex.scan(String.downcase(line))
          |> Enum.flat_map(& &1)

        [name] =
          sname
          |> String.split()
          |> Enum.join()
          |> to_atom()

        {name, String.to_integer(svalue)}
      end)
      |> create_boss()
    end

    defp create_boss({hitpoints, damage}), do: Boss.new(hitpoints, damage)

    defp create_boss(stats),
      do:
        stats
        |> Enum.reduce({nil, nil}, fn {key, value}, {hitpoints, damage} ->
          case key do
            :hitpoints -> {value, damage}
            :damage -> {hitpoints, value}
          end
        end)
        |> create_boss()

    defp to_atom(string), do: ~w"#{string}"a

    defp simply(module),
      do:
        module
        |> to_string()
        |> String.downcase()
        |> String.split(".")
        |> Enum.take(-1)
        |> Enum.flat_map(&~w"#{&1}"a)
        |> Enum.at(0)

    @spec execute(Boss.t(), module()) :: output()
    def execute(boss, module),
      do:
        module
        |> simply()
        |> execute(boss, spells(), effects(), Wizard.new(50, 500), {0, 0, 0}, 0, {nil, 0})

    defp spells,
      do:
        Map.new()
        |> Map.put(:magic_missile, Spell.new(53, damage: 4))
        |> Map.put(:drain, Spell.new(73, damage: 2, heal: 2))
        |> Map.put(:shield, Spell.new(113, effect: :shield, duration: 6))
        |> Map.put(:poison, Spell.new(173, effect: :poison, duration: 6))
        |> Map.put(:recharge, Spell.new(229, effect: :recharge, duration: 5))
        |> Map.values()

    defp effects,
      do:
        Map.new()
        |> Map.put(:shield, Effect.new(armor: 7))
        |> Map.put(:poison, Effect.new(damage: 3))
        |> Map.put(:recharge, Effect.new(mana: 101))

    defp play(%Wizard{} = wizard, %Boss{} = boss, active_effects, spell, effects, module),
      do:
        effects
        |> start_effects(active_effects, wizard, boss)
        |> kill_effects(wizard, boss, spell, module)
        |> update_effects(wizard, boss)

    defp kill_effects(
           {_, {_, boss_hitpoints, _}} = effects,
           %Wizard{hitpoints: wizard_hitpoints},
           _,
           _,
           _
         )
         when boss_hitpoints < 1 or wizard_hitpoints < 1, do: effects

    defp kill_effects(
           {effects, {_, boss_hitpoints, wizard_mana}},
           %Wizard{} = wizard,
           _,
           %Spell{} = spell,
           module
         ) do
      wizard_mana = wizard_mana - spell.cost
      newboss_hitpoints = boss_hitpoints - spell.damage
      wizard_hitpoints = wizard.hitpoints + spell.heal - hurt(module)

      new_effects = apply_effect(spell, effects)

      {wizard_mana, newboss_hitpoints, wizard_hitpoints, new_effects}
    end

    defp kill_effects(
           {effects, {wizard_armor, boss_hitpoints, wizard_mana}},
           %Wizard{} = wizard,
           %Boss{} = boss,
           _,
           _
         ) do
      wizard_hitpoints = wizard.hitpoints - max(1, boss.damage - wizard_armor)

      {wizard_mana, boss_hitpoints, wizard_hitpoints, effects}
    end

    defp hurt(:part1), do: 0
    defp hurt(:part2), do: 1

    defp apply_effect(%Spell{effect: :shield, duration: duration}, {0, poison, recharge}),
      do: {duration, poison, recharge}

    defp apply_effect(%Spell{effect: :poison, duration: duration}, {shield, 0, recharge}),
      do: {shield, duration, recharge}

    defp apply_effect(%Spell{effect: :recharge, duration: duration}, {shield, poison, 0}),
      do: {shield, poison, duration}

    defp apply_effect(%Spell{effect: nil}, effects), do: effects

    defp update_effects(
           {effects, {_, boss_hitpoints, wizard_mana}},
           %Wizard{} = wizard,
           %Boss{} = boss
         ) do
      new_wizard = %Wizard{wizard | mana: wizard_mana}
      new_boss = %Boss{boss | hitpoints: boss_hitpoints}

      {new_wizard, new_boss, effects}
    end

    defp update_effects(
           {wizard_mana, boss_hitpoints, wizard_hitpoints, effects},
           %Wizard{} = wizard,
           %Boss{} = boss
         ) do
      new_wizard = %Wizard{wizard | mana: wizard_mana, hitpoints: wizard_hitpoints}
      new_boss = %Boss{boss | hitpoints: boss_hitpoints}

      {new_wizard, new_boss, effects}
    end

    defp start_effects(effects, active_effects, %Wizard{} = wizard, %Boss{} = boss),
      do:
        Enum.reduce(
          effects,
          {active_effects, {wizard.armor, boss.hitpoints, wizard.mana}},
          &reduce_effect/2
        )

    defp reduce_effect({:shield, _}, {{0, _, _}, _} = acc), do: acc
    defp reduce_effect({:poison, _}, {{_, 0, _}, _} = acc), do: acc
    defp reduce_effect({:recharge, _}, {{_, _, 0}, _} = acc), do: acc

    defp reduce_effect(
           {:shield, %Effect{} = effect},
           {{shield, poison, recharge}, {wizard_armor, boss_hitpoints, wizard_mana}}
         ),
         do:
           {{shield - 1, poison, recharge},
            {wizard_armor + effect.armor, boss_hitpoints, wizard_mana}}

    defp reduce_effect(
           {:poison, %Effect{} = effect},
           {{shield, poison, recharge}, {wizard_armor, boss_hitpoints, wizard_mana}}
         ),
         do:
           {{shield, poison - 1, recharge},
            {wizard_armor, boss_hitpoints - effect.damage, wizard_mana}}

    defp reduce_effect(
           {:recharge, %Effect{} = effect},
           {{shield, poison, recharge}, {wizard_armor, boss_hitpoints, wizard_mana}}
         ),
         do:
           {{shield, poison, recharge - 1},
            {wizard_armor, boss_hitpoints, wizard_mana + effect.mana}}

    defp execute(
           module,
           %Boss{} = boss,
           spells,
           effects,
           %Wizard{} = wizard,
           active_effects,
           turns,
           {best_mana, mana}
         ),
         do:
           spells
           |> filter_spells(wizard, active_effects, turns)
           |> Enum.reduce(
             best_mana,
             &reduce_spell(
               &1,
               &2,
               {module, boss, spells, effects, wizard, active_effects, turns, mana}
             )
           )

    defp filter_spells(spells, %Wizard{} = wizard, effects, turns) when rem(turns, 2) < 1,
      do: Enum.filter(spells, &(&1.cost <= wizard.mana and available?(&1, effects)))

    defp filter_spells(_, _, _, _), do: [nil]

    defp reduce_spell(
           %Spell{} = spell,
           best_mana,
           {module, boss, spells, effects, wizard, active_effects, turns, mana}
         ) do
      {%Wizard{} = new_wizard, %Boss{} = new_boss, new_active} =
        play(wizard, boss, active_effects, spell, effects, module)

      inside_mana = mana + spell.cost

      handle_player(
        {module, new_boss, spells, effects, new_wizard, new_active, turns,
         {best_mana, inside_mana}}
      )
    end

    defp reduce_spell(
           nil = spell,
           best_mana,
           {module, boss, spells, effects, wizard, active_effects, turns, mana}
         ) do
      {%Wizard{} = new_wizard, %Boss{} = new_boss, new_active} =
        play(wizard, boss, active_effects, spell, effects, module)

      handle_boss(
        {module, new_boss, spells, effects, new_wizard, new_active, turns, {best_mana, mana}}
      )
    end

    defp handle_player(
           {module, new_boss, spells, effects, new_wizard, new_active, turns,
            {best_mana, inside_mana}}
         ) do
      cond do
        new_boss.hitpoints < 1 ->
          dead_boss(best_mana, inside_mana)

        best_mana === nil or inside_mana < best_mana ->
          execute(
            module,
            new_boss,
            spells,
            effects,
            new_wizard,
            new_active,
            turns + 1,
            {best_mana, inside_mana}
          )

        true ->
          best_mana
      end
    end

    defp handle_boss(
           {module, new_boss, spells, effects, new_wizard, new_active, turns,
            {best_mana, inside_mana}}
         ) do
      cond do
        new_wizard.hitpoints < 1 ->
          best_mana

        new_boss.hitpoints < 1 ->
          dead_boss(best_mana, inside_mana)

        true ->
          execute(
            module,
            new_boss,
            spells,
            effects,
            new_wizard,
            new_active,
            turns + 1,
            {best_mana, inside_mana}
          )
      end
    end

    defp dead_boss(nil, inside_mana), do: inside_mana
    defp dead_boss(best_mana, inside_mana) when inside_mana < best_mana, do: inside_mana
    defp dead_boss(best_mana, _), do: best_mana

    defp available?(%Spell{effect: nil}, _), do: true
    defp available?(%Spell{effect: :shield}, {time, _, _}), do: time < 2
    defp available?(%Spell{effect: :poison}, {_, time, _}), do: time < 2
    defp available?(%Spell{effect: :recharge}, {_, _, time}), do: time < 2
    defp available?(%Spell{}, _), do: false
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 22
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.execute(__MODULE__)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 22
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.execute(__MODULE__)
    end
  end
end
