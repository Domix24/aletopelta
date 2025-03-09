defmodule Aletopelta.Year2023.Day12 do
  @moduledoc """
  Day 12 of Year 2023
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 12
    """
    def parse_input(input) do
      Enum.map input, &parse_line/1
    end

    defp parse_line line do
      parsed = String.split line

      numbers = Enum.at(parsed, 1)
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

      line = Enum.at(parsed, 0)
      |> String.graphemes

      {line, numbers}
    end

    def process_line {line, groups}  do
      count_broken = Enum.count(line, & &1 == "#")

      process_line(line, groups, %{}, 0, {length(groups), count_broken})
      |> elem(1)
    end

    defp process_line _, [], memo, _, {0, 0} do
      {memo, 1}
    end
    defp process_line [], _, memo, _, _ do
      {memo, 0}
    end
    defp process_line _, [], memo, _, {0, _} do
      {memo, 0}
    end
    defp process_line line, groups, memo, index, {count_groups, count_broken} = infos do
      {[sign | others], index} = find_next line, index

      memo_key = {index, count_groups}
      memo_value = case Map.fetch memo, memo_key do
        {:ok, v} -> v
        _ -> :error
      end

      cond do
        sign == "." -> process_line [], groups, memo, index, infos
        memo_value != :error -> {memo, memo_value}
        true ->
          {memo, result} = Enum.reduce(0..1, {memo, 0}, fn
            0, {memo, res} ->
              process_first groups, others, count_broken, sign, memo, index, count_groups, res

            1, {memo, res} ->
              process_second sign, others, groups, memo, infos, res, index
          end)

          {Map.put(memo, memo_key, result), result}
      end
    end

    defp process_first groups, others, count_broken, sign, memo, index, count_groups, res do
      [group | groups] = groups

      if can_fill? others, (group - 1) do
        count_broken = get_broken count_broken, others, group, sign

        {memo, resu} = process_line Enum.drop(others, group), groups, memo, index + group + 1, {count_groups - 1, count_broken}
        {memo, resu + res}
      else
        {memo, res}
      end
    end

    defp get_broken count_broken, others, group, sign do
      count_broken = count_broken - (Enum.take(others, group) |> Enum.count(& &1 == "#"))
      count_broken - (if sign == "#", do: 1, else: 0)
    end

    defp process_second "?", others, groups, memo, infos, res, index do
      {memo, resu} = process_line others, groups, memo, index + 1, infos
      {memo, resu + res}
    end
    defp process_second _, _, _, memo, _, res, _ do
      {memo, res}
    end

    defp find_next(["."], index), do: {["."], index}
    defp find_next(["." | signs], index), do: find_next(signs, index + 1)
    defp find_next(line, index), do: {line, index}

    defp can_fill?([], n), do: n < 1
    defp can_fill?(["." | _],  n), do: n < 1
    defp can_fill?(["#" | _],  0), do: false
    defp can_fill?(["?" | _], -1), do: true
    defp can_fill?([_ | signs], n), do: can_fill?(signs, n - 1)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 12
    """
    def execute(input) do
      Common.parse_input(input)
      |> Enum.sum_by(&Common.process_line/1)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 12
    """
    def execute input do
      Common.parse_input(input)
      |> Enum.sum_by(&do_line/1)
    end

    defp do_line line do
      unfold(line, 5)
      |> Common.process_line
    end

    defp unfold {line, groups}, max do
      Enum.reduce(2..max//1, {line, groups}, fn _, {acc_line, acc_groups} ->
        {acc_line ++ ["?" | line], acc_groups ++ groups}
      end)
    end
  end
end
