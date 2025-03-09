defmodule Aletopelta.Year2023.Day19 do
  @moduledoc """
  Day 19 of Year 2023
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 19
    """
    def parse_input(input) do
      {_, {map, list}} = Enum.reduce input, {:workflows, {%{}, []}}, fn
        "", {:workflows, acc} -> {:ratings, acc}
        line, {:workflows, {map, list}} -> parse_workflows line, map, list
        line, {:ratings, {map, list}} -> parse_ratings line, map, list
      end

      {map, list}
    end

    defp parse_workflows line, map, list do
      [_, name, rules] = Regex.run ~r/^([a-z]+){([a-zA-Z0-9,<>:]+)}$/, line

      name = String.to_atom name

      rules = String.split(rules, ",")
      |> Enum.map(fn rule -> parse_rule rule end)

      map = Map.put map, name, rules
      {:workflows, {map, list}}
    end

    defp parse_rule rule do
      case String.contains?(rule, ":") do
        true ->
          parse_workflow rule

        false ->
          String.to_atom rule
      end
    end

    defp parse_workflow rule do
      [_, name, operator, value, result] = Regex.run ~r/^([a-z]+)(<|>)([0-9]+):([a-zA-Z]+)$/, rule

      name = String.to_atom name
      {operator, function} = case operator do
        "<" -> {:<, &Kernel.</2}
        ">" -> {:>, &Kernel.>/2}
      end
      {value, _} = Integer.parse value
      result = String.to_atom result

      function = fn rating ->
        if function.(Keyword.fetch!(rating, name), value) do
          result
        else
          false
        end
      end

      {name, operator, value, result, function}
    end

    defp parse_ratings line, map, list do
      rating = Regex.scan(~r/([a-zA-Z]+)=([0-9]+)/, line, capture: :all_but_first)
      |> Enum.reduce([], fn [key, value], keywords ->
        key = String.to_atom key
        {value, _} = Integer.parse value

        Keyword.put keywords, key, value
      end)

      {:ratings, {map, [rating | list]}}
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 19
    """
    def execute(input) do
      {map, list} = Common.parse_input input

      Enum.reduce list, 0, fn rating, sum ->
        follow_rule(rating, map, Map.fetch!(map, :in))
        |> case do
          :A -> do_sum rating
          :R -> 0
        end
        |> Kernel.+(sum)
      end
    end

    defp follow_rule rating, map, rule do
      Enum.reduce_while(rule, nil, fn
        {_, _, _, _, test}, _ ->
          case test.(rating) do
           :A -> {:halt, :A}
           :R -> {:halt, :R}
           false -> {:cont, nil}
           atom -> {:halt, {:continued, atom}}
          end
        :R, _ ->
          {:halt, :R}
        :A, _ ->
          {:halt, :A}
        atom, _ ->
          {:halt, {:continued, atom}}
      end)
      |> case do
        {:continued, atom} -> follow_rule rating, map, Map.fetch!(map, atom)
        :A -> :A
        :R -> :R
      end
    end

    defp do_sum [{_, n}] do
      n
    end
    defp do_sum [{_, n} | others] do
      n + do_sum others
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 19
    """
    def execute(input) do
      {map, _} = Common.parse_input input
      rating = [x: 1..4000, m: 1..4000, a: 1..4000, s: 1..4000]

      do_loop rating, map, :in
    end

    defp do_loop rating, map, atom do
      follow_rule(rating, Map.fetch!(map, atom))
      |> Enum.sum_by(&do_sum &1, map)
    end

    defp do_sum {_, :R}, _ do
      0
    end
    defp do_sum {rating, :A}, _ do
      Enum.reduce rating, 1, fn {_, interval}, product ->
        product * Range.size interval
      end
    end
    defp do_sum {rating, atom}, map do
      do_loop rating, map, atom
    end
    defp do_sum number, _ do
      number
    end

    defp follow_rule rating, rule do
      Enum.reduce(rule, {[], rating}, fn
        {name, :<, value, result, _}, {list, rating} ->
          part1 = Keyword.update! rating, name, fn first.._//1 -> first..(value - 1)//1 end
          part2 = Keyword.update! rating, name, fn _..last//1 -> value..last//1 end

          {[{part1, result} | list], part2}

        {name, :>, value, result, _}, {list, rating} ->
          part1 = Keyword.update! rating, name, fn first.._//1 -> first..value//1 end
          part2 = Keyword.update! rating, name, fn _..last//1 -> (value + 1)..last//1 end

          {[{part2, result} | list], part1}

        atom, {list, rating} ->
          {[{rating, atom} | list], nil}
      end) |> elem(0)
    end
  end
end
