defmodule Aletopelta.Year2018.Day14 do
  @moduledoc """
  Day 14 of Year 2018
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 14
    """

    @type input() :: list(binary())

    @spec parse_input(input()) :: binary()
    def parse_input(input) do
      Enum.at(input, 0)
    end

    defp ibuild_recipe(sum, recipes) when sum < 10 do
      new_recipes = <<recipes::binary, sum>>
      change = 1
      {new_recipes, change}
    end

    defp ibuild_recipe(sum, recipes) do
      new_recipes = <<recipes::binary, 1, sum - 10>>
      change = 2
      {new_recipes, change}
    end

    @spec build_recipe(binary(), integer(), integer()) :: {binary(), 1 | 2}
    def build_recipe(recipes, elf1, elf2),
      do:
        recipes
        |> :binary.at(elf1)
        |> Kernel.+(:binary.at(recipes, elf2))
        |> ibuild_recipe(recipes)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 14
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> String.to_integer()
      |> prepare_find()
      |> String.to_charlist()
      |> Enum.join()
      |> String.to_integer()
    end

    defp prepare_find(input), do: find_pattern(<<3, 7>>, 0, 1, input)

    defp find_pattern(recipes, elf1, elf2, pattern) do
      {new_recipes, size_change} = Common.build_recipe(recipes, elf1, elf2)

      new_recipes
      |> byte_size()
      |> handle_recipes(new_recipes, elf1, elf2, pattern, size_change)
    end

    defp handle_recipes(size, recipes, _, _, pattern, _) when size - 10 === pattern,
      do: binary_part(recipes, size, -10)

    defp handle_recipes(size, recipes, _, _, pattern, 2) when size - 11 === pattern,
      do: binary_part(recipes, size - 1, -10)

    defp handle_recipes(size, recipes, elf1, elf2, pattern, _) do
      new_elf1 = rem(:binary.at(recipes, elf1) + 1 + elf1, size)
      new_elf2 = rem(:binary.at(recipes, elf2) + 1 + elf2, size)
      find_pattern(recipes, new_elf1, new_elf2, pattern)
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
      |> String.to_charlist()
      |> Enum.map(&(&1 - ?0))
      |> to_string()
      |> prepare_find()
    end

    defp prepare_find(input), do: find_pattern(<<3, 7>>, 0, 1, input, byte_size(input))

    defp find_pattern(recipes, elf1, elf2, pattern, pattern_size) do
      {new_recipes, size_change} = Common.build_recipe(recipes, elf1, elf2)

      new_recipes
      |> byte_size()
      |> handle_size(new_recipes, pattern, pattern_size, size_change)
      |> handle_recipes(new_recipes, elf1, elf2, pattern, pattern_size)
    end

    defp handle_size(size, recipes, pattern, pattern_size, size_change) when size > pattern_size,
      do:
        recipes
        |> binary_part(size, -pattern_size)
        |> handle_binary(size, recipes, pattern, pattern_size, size_change)
        |> handle_next(size)

    defp handle_size(size, _, _, _, _), do: {:error, size}

    defp handle_binary(pattern, size, _, pattern, pattern_size, _), do: {:ok, size - pattern_size}

    defp handle_binary(_, size, recipes, pattern, pattern_size, 2),
      do: handle_size(size - 1, recipes, pattern, pattern_size, 1)

    defp handle_binary(_, _, _, _, _, _), do: {:error, nil}

    defp handle_next({:error, _}, size), do: {:error, size}
    defp handle_next(next, _), do: next

    defp handle_recipes({:error, size}, recipes, elf1, elf2, pattern, pattern_size) do
      new_elf1 = rem(:binary.at(recipes, elf1) + 1 + elf1, size)
      new_elf2 = rem(:binary.at(recipes, elf2) + 1 + elf2, size)
      find_pattern(recipes, new_elf1, new_elf2, pattern, pattern_size)
    end

    defp handle_recipes({:ok, result}, _, _, _, _, _), do: result
  end
end
