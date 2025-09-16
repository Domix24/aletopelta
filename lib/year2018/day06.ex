defmodule Aletopelta.Year2018.Day06 do
  @moduledoc """
  Day 6 of Year 2018
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 6
    """

    @type input() :: list(binary())
    @type position() :: %{x: integer(), y: integer()}

    @spec parse_input(input()) :: [%{x: integer(), y: integer(), index: integer()}]
    def parse_input(input) do
      Enum.with_index(input, fn line, index ->
        ~r"-?\d+"
        |> Regex.scan(line)
        |> Enum.map(fn [number] -> String.to_integer(number) end)
        |> then(fn [x, y] -> %{x: x, y: y, index: index} end)
      end)
    end

    @spec distance(position(), position()) :: integer()
    def distance(%{x: x1, y: y1}, %{x: x2, y: y2}), do: abs(x2 - x1) + abs(y2 - y1)

    @spec limit([position()]) :: %{
            min_x: integer(),
            min_y: integer(),
            max_x: integer(),
            max_y: integer()
          }
    def limit(coordinates) do
      {%{x: min_x}, %{x: max_x}} = Enum.min_max_by(coordinates, & &1.x)
      {%{y: min_y}, %{y: max_y}} = Enum.min_max_by(coordinates, & &1.y)

      %{min_x: min_x, min_y: min_y, max_x: max_x, max_y: max_y}
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 6
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> process_coordinates()
      |> Enum.frequencies()
      |> Enum.max_by(&elem(&1, 1))
      |> elem(1)
    end

    defp process_coordinates(coordinates) do
      limit = Common.limit(coordinates)
      infinity_set = infinity_set(coordinates, limit)

      for x <- (limit.min_x + 1)..(limit.max_x - 1),
          y <- (limit.min_y + 1)..(limit.max_y - 1),
          position = %{x: x, y: y},
          {closest_indices, unique?} = closest_coordinate(position, coordinates),
          unique?,
          index = hd(closest_indices),
          not MapSet.member?(infinity_set, index) do
        index
      end
    end

    defp closest_coordinate(position, coordinates) do
      distances =
        Enum.map(coordinates, fn coord ->
          {Common.distance(position, coord), coord.index}
        end)

      min_distance =
        distances
        |> Enum.map(&elem(&1, 0))
        |> Enum.min()

      closest_indices =
        distances
        |> Enum.filter(fn {dist, _} -> dist == min_distance end)
        |> Enum.map(&elem(&1, 1))

      {closest_indices, length(closest_indices) == 1}
    end

    defp infinity_set(coordinates, limit) do
      limit
      |> border_positions()
      |> Enum.flat_map(fn position ->
        {closest_indices, unique?} = closest_coordinate(position, coordinates)
        if unique?, do: closest_indices, else: []
      end)
      |> MapSet.new()
    end

    defp border_positions(limit) do
      top_bottom =
        for x <- limit.min_x..limit.max_x,
            y <- [limit.min_y, limit.max_y],
            do: %{x: x, y: y}

      left_right =
        for x <- [limit.min_x, limit.max_x],
            y <- (limit.min_y + 1)..(limit.max_y - 1),
            do: %{x: x, y: y}

      Enum.uniq(top_bottom ++ left_right)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 6
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> process_coordinates()
      |> length()
    end

    defp process_coordinates(coordinates) do
      limit = Common.limit(coordinates)

      for x <- limit.min_x..limit.max_x,
          y <- limit.min_y..limit.max_y,
          position = %{x: x, y: y},
          distance = total_distance(position, coordinates),
          distance < 10_000 do
        distance
      end
    end

    defp total_distance(position, coordinates) do
      coordinates
      |> Enum.map(&Common.distance(&1, position))
      |> Enum.sum()
    end
  end
end
