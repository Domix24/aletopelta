defmodule Aletopelta.Year2023.Day05 do
  @moduledoc """
  Day 5 of Year 2023
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 5
    """
    @pattern_title ~r/(\w+)-to-(\w+)/
    def parse_input(input) do
      parse_input(input, nil, nil)
      |> Enum.group_by(
        fn
          {{from, _}, _} -> from
          {what, _} -> what
        end,
        fn
          {{_, to}, list} -> {to, list}
          {_, list} -> list
        end
      )
    end

    def parse_input([], _, _), do: []
    def parse_input(["" | others], _, _), do: parse_input(others, nil, nil)

    def parse_input(["seeds:" <> numbers | others], nil, nil),
      do: [
        {:seeds, String.split(numbers) |> Enum.map(&String.to_integer/1)}
        | parse_input(others, nil, nil)
      ]

    def parse_input([first | others], from, to) do
      match = Regex.scan(@pattern_title, first, capture: :all_but_first)

      if length(match) == 1 do
        [[from, to]] = match
        parse_input(others, String.to_atom(from), String.to_atom(to))
      else
        [
          {{from, to}, String.split(first) |> Enum.map(&String.to_integer/1)}
          | parse_input(others, from, to)
        ]
      end
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 5
    """
    def execute(input) do
      almanac = Common.parse_input(input)

      Map.fetch!(almanac, :seeds)
      |> Enum.flat_map(& &1)
      |> Enum.map(&find_location(&1, almanac, :seed))
      |> Enum.min()
    end

    defp find_location(source_value, almanac, source_key) do
      result = Map.fetch(almanac, source_key)

      if result == :error do
        source_value
      else
        {source_key, source_value} =
          elem(result, 1)
          |> find_combinaison(source_value)

        source_value
        |> find_location(almanac, source_key)
      end
    end

    defp find_combinaison([{dest, _} | _] = list, source) do
      Enum.map(list, &elem(&1, 1))
      |> find_combinaison(dest, source)
    end

    defp find_combinaison([], dest_key, source_value), do: {dest_key, source_value}

    defp find_combinaison([[dest_range, source_range, length] | others], dest_key, source_value) do
      cond do
        source_range + length - 1 < source_value ->
          find_combinaison(others, dest_key, source_value)

        source_range > source_value ->
          find_combinaison(others, dest_key, source_value)

        true ->
          {dest_key, dest_range + source_value - source_range}
      end
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 5
    """
    def execute(input) do
      almanac = Common.parse_input(input)

      Map.fetch!(almanac, :seeds)
      |> Enum.flat_map(& &1)
      |> Enum.chunk_every(2)
      |> Enum.map(&find_location(&1, almanac, :seed))
      |> Enum.min()
    end

    defp find_location(source_value, almanac, source_key) do
      result = Map.fetch(almanac, source_key)

      if result == :error do
        source_value
      else
        {source_key, source_value} =
          elem(result, 1)
          |> find_combinaison(source_value)

        source_value
        |> Enum.reduce(nil, fn value, acc ->
          value
          |> find_location(almanac, source_key)
          |> get_minimum(acc)
        end)
      end
    end

    defp get_minimum([number | _], acc) do
      min(acc, number)
    end

    defp get_minimum(number, acc) do
      min(acc, number)
    end

    defp find_combinaison([{dest, _} | _] = list, source) do
      Enum.map(list, &elem(&1, 1))
      |> find_combinaison(dest, source)
    end

    defp find_combinaison([], dest_key, source_value), do: {dest_key, [source_value]}

    defp find_combinaison(
           [[dest_range, source_range, length] | others] = almanac,
           dest_key,
           [source_start, source_length] = source_value
         ) do
      almanac_range = Range.new(source_range, source_range + length - 1)
      input_range = Range.new(source_start, source_start + source_length - 1)

      if Range.disjoint?(almanac_range, input_range) do
        find_combinaison(others, dest_key, source_value)
      else
        destination_range = Range.new(dest_range, dest_range + length - 1)

        cond do
          input_range.first < almanac_range.first ->
            left_range = Range.new(input_range.first, almanac_range.first - 1)
            input_range = Range.new(almanac_range.first, input_range.last)

            {_, list_left} =
              find_combinaison(almanac, dest_key, [
                left_range.first,
                left_range.last - left_range.first + 1
              ])

            {key, list_input} =
              find_combinaison(almanac, dest_key, [
                input_range.first,
                input_range.last - input_range.first + 1
              ])

            {key, list_left ++ list_input}

          input_range.last < almanac_range.last + 1 ->
            left_range =
              Range.new(
                destination_range.first + input_range.first - almanac_range.first,
                destination_range.first + input_range.last - almanac_range.first
              )

            {dest_key, [[left_range.first, left_range.last - left_range.first + 1]]}

          true ->
            left_range =
              Range.new(
                destination_range.first + input_range.first - almanac_range.first,
                destination_range.first + almanac_range.last - almanac_range.first
              )

            input_range = Range.new(almanac_range.last + 1, input_range.last)

            {key, list} =
              find_combinaison(almanac, dest_key, [
                input_range.first,
                input_range.last - input_range.first + 1
              ])

            {key, [[left_range.first, left_range.last - left_range.first + 1] | list]}
        end
      end
    end
  end
end
