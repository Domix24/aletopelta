defmodule Aletopelta.Year2023.Day06 do
  @moduledoc """
  Day 6 of Year 2023
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 6
    """
    def parse_input(input) do
      times = parse_numbers(Enum.at(input, 0))
      distances = parse_numbers(Enum.at(input, 1))

      build_table(times, distances)
    end

    defp parse_numbers(line) do
      Regex.scan(~r/(\d+)/, line, capture: :first)
      |> Enum.map(fn [time] -> String.to_integer(time) end)
    end

    defp build_table([], []), do: []

    defp build_table([time1 | timex], [distance1 | distancex]) do
      [%{time: time1, distance: distance1} | build_table(timex, distancex)]
    end

    def get_zeros([]), do: []

    def get_zeros([%{time: time, distance: distance} | others]) do
      quadratic = Integer.pow(time, 2) - 4 * distance
      quadratic = Float.pow(String.to_float("#{quadratic}.0"), 0.5)

      positive =
        Integer.parse(Float.to_string((String.to_float("-#{time}.0") + quadratic) / -2.0))
        |> then(fn {number, _} -> number + 1 end)

      negative =
        Integer.parse(Float.to_string((String.to_float("-#{time}.0") - quadratic) / -2.0))
        |> case do
          {number, ".0"} -> number - 1
          {number, _} -> number
        end

      [Range.new(positive, negative) | get_zeros(others)]
    end

    def multiply(list) do
      Enum.reduce(list, 1, fn range, acc -> (range.last - range.first + 1) * acc end)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 6
    """
    def execute(input) do
      Common.parse_input(input)
      |> Common.get_zeros()
      |> Common.multiply()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 6
    """
    def execute(input) do
      Common.parse_input(input)
      |> convert_input
      |> Common.get_zeros()
      |> Common.multiply()
    end

    defp convert_input(input) do
      time = convert_one(input, fn line -> line.time end)
      distance = convert_one(input, fn line -> line.distance end)

      [%{time: time, distance: distance}]
    end

    defp convert_one(input, get_key) do
      Enum.map_join(input, &get_key.(&1))
      |> String.to_integer()
    end
  end
end
