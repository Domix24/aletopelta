defmodule Aletopelta.Year2022.Day03 do
  @moduledoc """
  Day 3 of Year 2022
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 3
    """
    @spec parse_input(any()) :: nil
    def parse_input(_) do
    end

    @spec score_all(list()) :: list()
    def score_all([]), do: []

    def score_all([[first_group | other_groups] | groups]) do
      {score_list, groups_left} =
        first_group
        |> String.graphemes()
        |> Enum.reduce_while({[], groups}, fn item, {score_list, groups_left} ->
          in_others? = Enum.all?(other_groups, &String.contains?(&1, item))
          priority = compute_priority(item)

          {match, groups_new} = filter_groups(groups_left, item)
          add_score = Enum.count(match) * priority

          if in_others? do
            {:halt, {[priority + add_score | score_list], groups_new}}
          else
            {:cont, {[add_score | score_list], groups_new}}
          end
        end)

      score_list ++ score_all(groups_left)
    end

    defp filter_groups(groups, item) do
      Enum.split_with(groups, fn groups ->
        Enum.all?(groups, &String.contains?(&1, item))
      end)
    end

    defp compute_priority(<<item>>) do
      if item in ?A..?Z do
        item - 38
      else
        item - 96
      end
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 3
    """
    @spec execute(any()) :: integer()
    def execute(input) do
      input
      |> parse_input()
      |> Common.score_all()
      |> Enum.sum()
    end

    defp parse_input(input) do
      Enum.map(input, fn line ->
        length = String.length(line)
        {comp1, comp2} = String.split_at(line, div(length, 2))
        [comp1, comp2]
      end)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 3
    """
    @spec execute(any()) :: integer()
    def execute(input) do
      input
      |> parse_input()
      |> Common.score_all()
      |> Enum.sum()
    end

    defp parse_input(input) do
      {groups, _, _} =
        Enum.reduce(input, {[], [], 0}, fn line, {groups, lines, count} ->
          new_group = [line | lines]
          new_count = count + 1

          if new_count == 3 do
            {[new_group | groups], [], 0}
          else
            {groups, new_group, new_count}
          end
        end)

      groups
    end
  end
end
