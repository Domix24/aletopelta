defmodule Aletopelta.Year2021.Day08 do
  @moduledoc """
  Day 8 of Year 2021
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 8
    """
    @spec parse_input([binary()]) :: [[binary()]]
    def parse_input(input) do
      Enum.map(input, fn line ->
        line
        |> String.split("|")
        |> Enum.map(fn part ->
          part
          |> String.split()
          |> Enum.map(&String.graphemes/1)
        end)
      end)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 8
    """
    @spec execute([binary()], []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Enum.sum_by(&get_simple/1)
    end

    defp get_simple([digit | digits], :two),
      do: get_simple(digit, :three) + get_simple(digits, :two)

    defp get_simple([], :two), do: 0

    defp get_simple(digit, :three) when length(digit) == 2, do: 1
    defp get_simple(digit, :three) when length(digit) == 3, do: 1
    defp get_simple(digit, :three) when length(digit) == 4, do: 1
    defp get_simple(digit, :three) when length(digit) == 7, do: 1
    defp get_simple(_, :three), do: 0

    defp get_simple([_, digits]), do: get_simple(digits, :two)
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 8
    """
    @spec execute([binary()], []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> map_patterns()
      |> Enum.sum_by(&translate_output/1)
    end

    defp map_patterns(digits) do
      first = Enum.at(~c/a/, 0)

      mapping =
        0..6//1
        |> Range.shift(first)
        |> Map.new(fn index -> {<<index>>, nil} end)

      Enum.map(digits, fn [patterns, output] ->
        grouped =
          patterns
          |> Enum.group_by(&length/1)
          |> Enum.to_list()

        new_mapping =
          grouped
          |> map_simple(mapping)
          |> map_complex(grouped)

        {new_mapping, output}
      end)
    end

    defp translate_output({mapping, output}) do
      mapping
      |> translate(output)
      |> Enum.join()
      |> String.to_integer()
    end

    defp translate(_, []), do: []

    defp translate(mapping, [output | outputs]) do
      [translate(mapping, output, :single) | translate(mapping, outputs)]
    end

    defp translate(_, output, :single) when length(output) == 2, do: 1
    defp translate(_, output, :single) when length(output) == 3, do: 7
    defp translate(_, output, :single) when length(output) == 4, do: 4
    defp translate(_, output, :single) when length(output) == 7, do: 8

    defp translate(mapping, output, :single) when length(output) == 5 do
      cond do
        translate_two?(mapping, output) -> 2
        translate_three?(mapping, output) -> 3
        true -> 5
      end
    end

    defp translate(mapping, output, :single) when length(output) == 6 do
      cond do
        translate_zero?(mapping, output) -> 0
        translate_six?(mapping, output) -> 6
        true -> 9
      end
    end

    defp translate_zero?(mapping, output) do
      translate_number?(["a", "b", "c", "e", "f", "g"], mapping, output)
    end

    defp translate_two?(mapping, output) do
      translate_number?(["a", "c", "d", "e", "g"], mapping, output)
    end

    defp translate_three?(mapping, output) do
      translate_number?(["a", "c", "d", "f", "g"], mapping, output)
    end

    defp translate_six?(mapping, output) do
      translate_number?(["a", "b", "d", "e", "f", "g"], mapping, output)
    end

    defp translate_number?(segments, mapping, output) do
      Enum.all?(segments, fn segment ->
        [value] = Map.fetch!(mapping, segment)
        Enum.member?(output, value)
      end)
    end

    defp map_simple([{2, [pattern]} | others], mapping) do
      new_mapping =
        mapping
        |> Map.put("c", pattern)
        |> Map.put("f", pattern)

      map_simple(others, new_mapping)
    end

    defp map_simple([{3, [pattern]} | others], mapping) do
      impossible = Map.fetch!(mapping, "c")
      new_pattern = Enum.reject(pattern, &Enum.member?(impossible, &1))

      new_mapping = Map.put(mapping, "a", new_pattern)

      map_simple(others, new_mapping)
    end

    defp map_simple([{4, [pattern]} | others], mapping) do
      impossible = Map.fetch!(mapping, "c")
      new_pattern = Enum.reject(pattern, &Enum.member?(impossible, &1))

      new_mapping =
        mapping
        |> Map.put("b", new_pattern)
        |> Map.put("d", new_pattern)

      map_simple(others, new_mapping)
    end

    defp map_simple([{7, [pattern]} | others], mapping) do
      impossible = Enum.flat_map(["a", "b", "c"], &Map.fetch!(mapping, &1))
      new_pattern = Enum.reject(pattern, &Enum.member?(impossible, &1))

      new_mapping =
        mapping
        |> Map.put("e", new_pattern)
        |> Map.put("g", new_pattern)

      map_simple(others, new_mapping)
    end

    defp map_simple([_ | others], mapping), do: map_simple(others, mapping)
    defp map_simple([], mapping), do: mapping

    defp map_complex(mapping, [{5, patterns} | others]) do
      patterns
      |> map_five(mapping)
      |> complex_wrapper(others)
    end

    defp map_complex(mapping, [_ | others]), do: map_complex(mapping, others)

    defp complex_wrapper([mapping], patterns) do
      complete? = Enum.all?(mapping, fn {_, values} -> length(values) == 1 end)

      if complete? do
        mapping
      else
        map_complex(mapping, patterns)
      end
    end

    defp map_five([], mapping), do: [mapping]

    defp map_five([pattern | patterns], mapping) do
      pattern
      |> map_five(mapping, pattern)
      |> Enum.filter(&five?(&1, pattern))
      |> Enum.flat_map(fn mapping ->
        map_five(patterns, mapping)
      end)
    end

    defp map_five([], mapping, _), do: [mapping]

    defp map_five([segment | segments], mapping, pattern) do
      mapping
      |> Enum.flat_map(&map_segment(&1, segment, pattern))
      |> regroup()
      |> Enum.flat_map(fn list ->
        new_mapping =
          Enum.reduce(list, mapping, fn {segment, value}, acc ->
            Map.put(acc, segment, [value])
          end)

        map_five(segments, new_mapping, pattern)
      end)
    end

    defp map_segment({position, list}, segment, pattern) do
      if Enum.member?(list, segment) do
        list
        |> Enum.filter(&Enum.member?(pattern, &1))
        |> Enum.map(fn segment -> {position, segment} end)
      else
        []
      end
    end

    defp regroup(list) do
      regroup(list, [])
    end

    defp regroup([], groups), do: groups

    defp regroup(list, groups) do
      case build_group(list, [], MapSet.new()) do
        {[], _} -> raise "never"
        {group, leftover} -> regroup(leftover, [group | groups])
      end
    end

    defp build_group([], group, _), do: {group, []}

    defp build_group([{first, second} = tuple | rest], group, used) do
      if MapSet.member?(used, {:first, first}) or MapSet.member?(used, {:second, second}) do
        {remaining, leftover} = build_group(rest, group, used)
        {remaining, [tuple | leftover]}
      else
        new_used =
          used
          |> MapSet.put({:first, first})
          |> MapSet.put({:second, second})

        build_group(rest, [tuple | group], new_used)
      end
    end

    defp five?(mapping, pattern) do
      new_mapping =
        Enum.map(mapping, fn
          {_, [value]} ->
            if Enum.member?(pattern, value) do
              {true, value}
            else
              {false, nil}
            end

          _ ->
            {false, nil}
        end)

      valid? =
        new_mapping
        |> Enum.frequencies_by(&elem(&1, 1))
        |> Enum.all?(fn
          {nil, count} -> count == 2
          {_, count} -> count == 1
        end)

      if valid? do
        new_mapping
        |> Enum.map(&elem(&1, 0))
        |> five?()
      else
        false
      end
    end

    defp five?([true, false, true, true, true, false, true]), do: true
    defp five?([true, false, true, true, false, true, true]), do: true
    defp five?([true, true, false, true, false, true, true]), do: true
    defp five?(_), do: false
  end
end
