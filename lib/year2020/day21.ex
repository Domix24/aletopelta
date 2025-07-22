defmodule Aletopelta.Year2020.Day21 do
  @moduledoc """
  Day 21 of Year 2020
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 21
    """

    @type input() :: list(binary())
    @type output() :: list({list(binary()), list(binary())})
    @type complete() :: {output(), %{binary() => integer()}, list(binary()), list(binary())}

    @spec parse_input(input()) :: output()
    def parse_input(input) do
      Enum.map(input, fn line ->
        [[singredients, sallergens]] =
          Regex.scan(~r/(.*) \(contains (.*)\)/, line, capture: :all_but_first)

        ingredients = String.split(singredients, " ")
        allergens = String.split(sallergens, ", ")
        {ingredients, allergens}
      end)
    end

    @spec prepare_part(output()) :: complete()
    def prepare_part(list),
      do:
        list
        |> get_ingredients()
        |> get_allergens()
        |> find_dangerous()

    defp get_ingredients(list),
      do:
        list
        |> Enum.flat_map(&elem(&1, 0))
        |> Enum.frequencies()
        |> then(&{list, &1})

    defp get_allergens({list, ingredients}),
      do:
        list
        |> Enum.flat_map(&elem(&1, 1))
        |> Enum.frequencies()
        |> Map.keys()
        |> then(&{list, ingredients, &1})

    defp find_dangerous({list, ingredients, allergens}),
      do:
        allergens
        |> Enum.flat_map(&prepare_union(list, &1))
        |> Enum.uniq()
        |> then(&{list, ingredients, allergens, &1})

    defp prepare_union(list, allergen),
      do:
        list
        |> Enum.filter(fn {_, suballergen} -> Enum.member?(suballergen, allergen) end)
        |> Enum.map(&elem(&1, 0))
        |> union()

    @spec union(list()) :: list()
    def union(list),
      do:
        Enum.reduce(list, fn list, acc ->
          (list ++ acc)
          |> Enum.frequencies()
          |> Enum.filter(&(elem(&1, 1) > 1))
          |> Enum.map(&elem(&1, 0))
        end)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 21
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.prepare_part()
      |> count_inert()
    end

    defp count_inert({_, ingredients, _, danger}),
      do:
        ingredients
        |> Enum.reject(&Enum.member?(danger, elem(&1, 0)))
        |> Enum.sum_by(&elem(&1, 1))
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 21
    """
    @spec execute(Common.input(), []) :: binary()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.prepare_part()
      |> do_things()
      |> Enum.sort_by(&elem(&1, 0))
      |> Enum.map_join(",", &elem(&1, 1))
    end

    defp do_things({list, _, allergens, danger}), do: do_things({list, allergens, danger}, [])

    defp do_things({_, [], []}, mapping), do: mapping

    defp do_things({list, [_ | _] = allergens, danger}, mapping),
      do:
        allergens
        |> Enum.map(&reduce_allergens(&1, list, danger))
        |> Enum.split_with(&(length(elem(&1, 1)) < 2))
        |> clean(danger, allergens)
        |> prepare_mapping(mapping)
        |> then(&do_things({list, elem(&1, 1), elem(&1, 0)}, elem(&1, 2)))

    defp reduce_allergens(allergen, list, danger) do
      list
      |> Enum.filter(fn {_, suballergen} -> Enum.member?(suballergen, allergen) end)
      |> Enum.reduce(danger, &Common.union([elem(&1, 0), &2]))
      |> then(&{allergen, &1})
    end

    defp clean({unique, _}, danger, allergen),
      do:
        danger
        |> clean_danger(unique)
        |> prepare_clean(allergen, unique)

    defp clean_danger(danger, unique), do: danger -- Enum.flat_map(unique, &elem(&1, 1))

    defp prepare_clean(new_danger, allergens, unique),
      do:
        allergens
        |> clean_allergens(unique)
        |> then(&{new_danger, &1, unique})

    defp clean_allergens(allergens, unique), do: allergens -- Enum.map(unique, &elem(&1, 0))

    defp prepare_mapping({danger, allergens, unique}, mapping),
      do:
        unique
        |> Enum.map(fn {allergen, [ingredient]} -> {allergen, ingredient} end)
        |> Enum.concat(mapping)
        |> then(&{danger, allergens, &1})
  end
end
