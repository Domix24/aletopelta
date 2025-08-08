defmodule Aletopelta.Year2019.Day14 do
  @moduledoc """
  Day 14 of Year 2019
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 14
    """

    @type input() :: list(binary())
    @type recipes() :: %{binary() => {integer(), list({integer(), binary()})}}

    @spec parse_input(input()) :: recipes()
    def parse_input(input) do
      Map.new(input, fn line ->
        ~r/(.*) => (\d+) ([A-Z]+)/
        |> Regex.scan(line, capture: :all_but_first)
        |> Enum.flat_map(& &1)
        |> then(fn [recipe, amount, chemical] ->
          {chemical, {String.to_integer(amount), parse_recipe(recipe)}}
        end)
      end)
    end

    defp parse_recipe(recipe) do
      recipe
      |> String.split(", ")
      |> Enum.map(fn subrecipe ->
        [amount, chemical] = String.split(subrecipe)
        {String.to_integer(amount), chemical}
      end)
    end

    @spec get_ore(recipes(), binary(), integer()) :: integer()
    def get_ore(recipes, chemical, quantity) do
      recipes
      |> get_ore(chemical, quantity, Map.new())
      |> elem(0)
    end

    defp get_ore(recipes, chemical, quantity, leftovers) do
      needed = quantity - Map.get(leftovers, chemical, 0)

      continue_ore(recipes, chemical, quantity, needed, leftovers)
    end

    defp continue_ore(_, chemical, quantity, 0, leftovers) do
      new_leftovers = Map.update!(leftovers, chemical, &(&1 - quantity))
      {0, new_leftovers}
    end

    defp continue_ore(recipes, chemical, _, needed, leftovers) do
      {produced, recipe} = Map.fetch!(recipes, chemical)
      times = ceil(needed / produced)
      new_leftovers = Map.put(leftovers, chemical, produced * times - needed)

      Enum.reduce(recipe, {0, new_leftovers}, &reduce_recipe(&1, &2, times, recipes))
    end

    defp reduce_recipe({ore, "ORE"}, {sum, leftovers}, multiplier, _),
      do: {ore * multiplier + sum, leftovers}

    defp reduce_recipe({amount, chemical}, {sum, leftovers}, multiplier, recipes) do
      {new_amount, new_leftovers} = get_ore(recipes, chemical, amount * multiplier, leftovers)
      {sum + new_amount, new_leftovers}
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 14
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.get_ore("FUEL", 1)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 14
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> do_loop()
    end

    defp do_loop(recipes) do
      index = 0
      max = 1_000_000_000_000
      step = Integer.floor_div(max, 10)

      do_loop(recipes, "FUEL", index, step, max)
    end

    defp do_loop(recipes, chemical, index, step, max) do
      new_index = index + step
      ore = Common.get_ore(recipes, chemical, new_index)

      cond do
        ore < max ->
          do_loop(recipes, chemical, new_index, step, max)

        ore > max and step > 1 ->
          do_loop(recipes, chemical, new_index - step, Integer.floor_div(step, 10), max)

        ore > max && step == 1 ->
          new_index - 1
      end
    end
  end
end
