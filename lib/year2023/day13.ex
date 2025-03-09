defmodule Aletopelta.Year2023.Day13 do
  @moduledoc """
  Day 13 of Year 2023
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 13
    """
    def parse_input(input) do
      Enum.chunk_while(
        input,
        [],
        fn
          "", acc -> {:cont, Enum.reverse(acc) |> create_grid, []}
          line, acc -> {:cont, [line | acc]}
        end,
        fn acc -> {:cont, Enum.reverse(acc) |> create_grid, []} end
      )
    end

    defp create_grid(grid) do
      Enum.with_index(grid, fn line, row_index ->
        String.graphemes(line)
        |> Enum.with_index(&{{&2, row_index}, &1})
      end)
      |> Enum.flat_map(& &1)
      |> Map.new()
    end

    def find_combinations(list, callback?) do
      find_combinations(list, 2, [], [], fn [index1, index2] ->
        index2 - index1 == 1 and callback?.(index1, index2)
      end)
    catch
      {:found, value} -> value
    end

    defp find_combinations(_, 0, acc, result, callback?) do
      acc = Enum.sort(acc)

      if callback?.(acc) do
        throw({:found, acc})
      else
        result
      end
    end

    defp find_combinations([], _, _, result, _) do
      result
    end

    defp find_combinations([head | tail], length, acc, result, callback?) do
      with_head = find_combinations(tail, length - 1, [head | acc], result, callback?)
      find_combinations(tail, length, acc, with_head, callback?)
    end

    def find_reflexion(input) do
      case find_vertical(input) do
        [index, _] ->
          [vertical: index]

        _ ->
          [index, _] = find_horizontal(input)

          [horizontal: index]
      end
    end

    defp find_vertical(input) do
      find_reflexion(input, &elem(&1, 0), &elem(&1, 1))
    end

    defp find_horizontal(input) do
      find_reflexion(input, &elem(&1, 1), &elem(&1, 0))
    end

    def get_sum(input, get_key, get_value) do
      Enum.group_by(input, &get_key.(elem(&1, 0)), fn
        {key, "#"} -> Integer.pow(2, get_value.(key))
        {_, _} -> 0
      end)
      |> Map.new(fn {key, list} -> {key, Enum.sum(list)} end)
    end

    def find_reflexion(input, get_key, get_value) do
      sums = get_sum(input, get_key, get_value)

      Enum.group_by(sums, &elem(&1, 1), &elem(&1, 0))
      |> Enum.reduce_while(nil, fn
        {_, [_ | _] = list}, _ ->
          find_combinations(list, fn v1, v2 ->
            reflexion?(sums, v1 - 1, v2 + 1)
          end)
          |> case do
            [_, _] = list -> {:halt, list}
            _ -> {:cont, nil}
          end

        _, acc ->
          {:cont, acc}
      end)
    end

    def reflexion?(sums, index1, index2) do
      sumindex1 = Map.fetch(sums, index1)
      sumindex2 = Map.fetch(sums, index2)

      case {sumindex1, sumindex2} do
        {{:ok, v}, {:ok, v}} -> reflexion?(sums, index1 - 1, index2 + 1)
        {{:ok, _}, {:ok, _}} -> false
        _ -> true
      end
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 13
    """
    def execute(input) do
      Common.parse_input(input)
      |> Enum.sum_by(fn input ->
        Common.find_reflexion(input)
        |> case do
          [horizontal: value] -> (value + 1) * 100
          [vertical: value] -> value + 1
        end
      end)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 13
    """
    def execute(input) do
      Common.parse_input(input)
      |> Enum.sum_by(fn input ->
        Common.find_reflexion(input)
        |> find_reflexion(input)
        |> case do
          [horizontal: value] -> (value + 1) * 100
          [vertical: value] -> value + 1
        end
      end)
    end

    def find_reflexion(reflexion, input) do
      case find_vertical(reflexion, input) do
        [index, _] ->
          [vertical: index]

        _ ->
          [index, _] = find_horizontal(reflexion, input)

          [horizontal: index]
      end
    end

    def do_false(_) do
      false
    end

    defp find_vertical([vertical: index], input) do
      find_reflexion(input, &elem(&1, 0), &elem(&1, 1), &(&1 == index))
    end

    defp find_vertical(_, input) do
      find_reflexion(input, &elem(&1, 0), &elem(&1, 1), &do_false/1)
    end

    defp find_horizontal([horizontal: index], input) do
      find_reflexion(input, &elem(&1, 1), &elem(&1, 0), &(&1 == index))
    end

    defp find_horizontal(_, input) do
      find_reflexion(input, &elem(&1, 1), &elem(&1, 0), &do_false/1)
    end

    def find_reflexion(input, get_key, get_value, is_same?) do
      sums = Common.get_sum(input, get_key, get_value)

      {state, _, choices} =
        Enum.reduce_while(sums, {nil, Map.to_list(sums), MapSet.new()}, fn
          {key, sum}, {changed, [_ | acc], choices} ->
            Enum.reduce_while(acc, {nil, choices}, fn
              {_, ^sum}, acc ->
                {:cont, acc}

              {child_key, child_sum}, {_, choices} = acc ->
                find_onedifference(choices, acc, child_key, key, sum, child_sum)
            end)
            |> case do
              {nil, _} -> {:cont, {changed, acc, choices}}
              {:found, choices} -> {:cont, {true, acc, choices}}
            end

          _, acc ->
            {:halt, acc}
        end)

      if state do
        Enum.reduce_while(choices, nil, fn {index1, index2, choices}, _ ->
          loop_choices(choices, sums, index1, index2, is_same?)
        end)
      else
        nil
      end
    end

    defp find_onedifference(choices, acc, child_key, key, sum, child_sum) do
      cond do
        rem(abs(child_key - key), 2) == 0 ->
          {:cont, acc}

        Bitwise.band(Bitwise.bxor(sum, child_sum), Bitwise.bxor(sum, child_sum) - 1) == 0 ->
          {:cont, {:found, MapSet.put(choices, {key, child_key, [sum, child_sum]})}}

        true ->
          {:cont, acc}
      end
    end

    defp two_elements([_, _] = list) do
      {:halt, list}
    end

    defp two_elements(_) do
      {:cont, nil}
    end

    defp tryfind_combination(list, is_same?, sums) do
      Common.find_combinations(list, fn v1, v2 ->
        !is_same?.(v1) and Common.reflexion?(sums, v1 - 1, v2 + 1)
      end)
      |> two_elements
    end

    defp find_grouping(list, is_same?, sums) do
      Enum.reduce_while(list, nil, fn
        {_, [_ | _] = list}, _ ->
          tryfind_combination(list, is_same?, sums)

        _, _ ->
          {:cont, nil}
      end)
      |> two_elements
    end

    defp loop_choices(choices, sums, index1, index2, is_same?) do
      Enum.reduce_while(choices, nil, fn choice, _ ->
        sums = Map.put(sums, index1, choice)
        sums = Map.put(sums, index2, choice)

        Enum.group_by(sums, &elem(&1, 1), &elem(&1, 0))
        |> find_grouping(is_same?, sums)
      end)
      |> two_elements
    end
  end
end
