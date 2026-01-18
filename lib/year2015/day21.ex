defmodule Aletopelta.Year2015.Day21 do
  @moduledoc """
  Day 21 of Year 2015
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 21
    """

    @type input() :: list(binary())
    @type output() :: integer()
    @type boss() :: %{
            hitpoints: integer(),
            damage: integer(),
            armor: integer(),
            type: :boss | :player
          }

    @spec parse_input(input()) :: boss()
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
      |> create_player(:boss)
    end

    defp create_player(stats, :boss = type),
      do:
        stats
        |> Map.new()
        |> Map.put(:type, type)

    defp create_player(stats, :player = type),
      do:
        stats
        |> create_player(:boss)
        |> Map.put(:type, type)
        |> Map.put(:hitpoints, 100)

    defp create_object({_, {cost, damage, armor}}),
      do:
        Map.new()
        |> Map.put(:cost, cost)
        |> Map.put(:damage, damage)
        |> Map.put(:armor, armor)

    defp to_atom(string), do: ~w"#{string}"a

    defp load do
      weapons = [
        dagger: {8, 4, 0},
        shortsword: {10, 5, 0},
        warhammer: {25, 6, 0},
        longsword: {40, 7, 0},
        greataxe: {74, 8, 0}
      ]

      armors = [
        leather: {13, 0, 1},
        chainmail: {31, 0, 2},
        splintmail: {53, 0, 3},
        bandedmail: {75, 0, 4},
        platemail: {102, 0, 5}
      ]

      rings = [
        damage1: {25, 1, 0},
        damage2: {50, 2, 0},
        damage3: {100, 3, 0},
        defense1: {20, 0, 1},
        defense2: {40, 0, 2},
        defense3: {80, 0, 3}
      ]

      Enum.map([weapons, armors, rings], fn objects -> Enum.map(objects, &create_object/1) end)
    end

    defp cartesian_product([weapons, armors, rings]) do
      for weapon <- weapons,
          armor <- combinations(armors, 0..1),
          ring <- combinations(rings, 0..2) do
        combine([weapon] ++ armor ++ ring)
      end
    end

    defp combinations(list, lengths), do: Enum.flat_map(lengths, &combination(list, &1))
    defp combination(_, 0), do: [[]]
    defp combination([], _), do: []

    defp combination([head | tail], k) do
      with_head = for rest <- combination(tail, k - 1), do: [head | rest]
      with_head ++ combination(tail, k)
    end

    defp combine(list),
      do:
        list
        |> Enum.zip_with(& &1)
        |> Enum.flat_map(& &1)
        |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))
        |> Map.new(fn {key, values} -> {key, Enum.sum(values)} end)

    @spec execute(boss(), module()) :: output()
    def execute(boss, module),
      do:
        module
        |> simply()
        |> execute(boss, :internal)

    defp execute(module, boss, :internal),
      do:
        load()
        |> cartesian_product()
        |> Enum.filter(fn stats ->
          {boss, create_player(stats, :player)}
          |> Stream.iterate(&play/1)
          |> Enum.find_value(&find_value/1)
          |> filter(module)
        end)
        |> bound(module)
        |> gold()

    defp find_value({_, player}), do: find_value(player)
    defp find_value(%{type: type, hitpoints: hitpoints}) when hitpoints < 1, do: winlose(type)
    defp find_value(_), do: nil

    defp winlose(:boss), do: :win
    defp winlose(:player), do: :lose

    defp filter(state, :part1), do: state === :win
    defp filter(state, :part2), do: state === :lose

    defp bound(stats, :part1), do: Enum.min_by(stats, &gold/1)
    defp bound(stats, :part2), do: Enum.max_by(stats, &gold/1)

    defp play({player1, player2}),
      do:
        player2
        |> attack(player1)
        |> format(player2)

    defp format(player1, player2), do: {player2, player1}

    defp attack(player1, player2),
      do: Map.update!(player2, :hitpoints, &(&1 - max(1, player1.damage - player2.armor)))

    defp gold(%{cost: cost}), do: cost

    defp simply(module),
      do:
        module
        |> to_string()
        |> String.downcase()
        |> String.split(".")
        |> Enum.take(-1)
        |> Enum.flat_map(&~w"#{&1}"a)
        |> Enum.at(0)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 21
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
    Part 2 of Day 21
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.execute(__MODULE__)
    end
  end
end
