defmodule Aletopelta.Year2018.Day23 do
  @moduledoc """
  Day 23 of Year 2018
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 23
    """

    @type input() :: list(binary())
    @type position() :: %{x: integer(), y: integer(), z: integer()}

    @spec parse_input(input()) ::
            list(%{x: integer(), y: integer(), z: integer(), radius: integer()})
    def parse_input(input) do
      Enum.map(input, fn line ->
        [x, y, z, radius] =
          ~r"-?\d+"
          |> Regex.scan(line)
          |> Enum.flat_map(& &1)
          |> Enum.map(&String.to_integer/1)

        %{x: x, y: y, z: z, radius: radius}
      end)
    end

    @spec distance(position(), position()) :: integer()
    def distance(position1, position2) do
      Enum.sum_by([:x, :y, :z], fn coordinate ->
        coordinate1 = Map.fetch!(position1, coordinate)
        coordinate2 = Map.fetch!(position2, coordinate)

        abs(coordinate1 - coordinate2)
      end)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 23
    """
    @spec execute(Common.input(), []) :: any()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> do_part()
    end

    defp do_part(input) do
      strongest = Enum.max_by(input, & &1.radius)

      Enum.count(input, fn position ->
        distance = Common.distance(position, strongest)
        distance < strongest.radius
      end)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 23
    """
    @spec execute(Common.input(), []) :: any()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> do_part()
    end

    defp do_part(input) do
      box =
        [:x, :y, :z]
        |> Map.new(fn coordinate ->
          {min, max} = Enum.min_max_by(input, &Map.fetch!(&1, coordinate))
          {coordinate, min[coordinate]..max[coordinate]}
        end)
        |> count(input)

      do_loop([box], input)
    end

    defp do_loop(boxes, bots) do
      boxes
      |> Enum.reduce(nil, fn
        box, nil -> {box, []}
        box, {best, boxes} when best.count > box.count -> {best, [box | boxes]}
        box, {best, boxes} -> {box, [best | boxes]}
      end)
      |> continue_loop(bots)
    end

    defp continue_loop({best, boxes}, bots) do
      if unit?(best) do
        Common.distance(%{x: best.x.first, y: best.y.first, z: best.z.first}, %{x: 0, y: 0, z: 0}) -
          1
      else
        best
        |> split(bots)
        |> Enum.reduce(boxes, &[&1 | &2])
        |> do_loop(bots)
      end
    end

    defp unit?(box) do
      Enum.all?([:x, :y, :z], fn coordinate ->
        box[coordinate].first === box[coordinate].last
      end)
    end

    defp split(box, bots) do
      for xrange <- split(box.x), yrange <- split(box.y), zrange <- split(box.z) do
        count(%{x: xrange, y: yrange, z: zrange}, bots)
      end
    end

    defp split(first..first//1), do: [first..first]

    defp split(first..last//1 = range) do
      half =
        range
        |> Range.size()
        |> div(2)

      first_half = first..(first + half)
      second_half = (first + half + 1)..last

      [first_half, second_half]
    end

    defp count(box, bots) do
      count =
        Enum.count(bots, fn bot ->
          position =
            Map.new([:x, :y, :z], fn coordinate ->
              {actual, min, max} = {bot[coordinate], box[coordinate].first, box[coordinate].last}

              new_actual = coordinate(actual, min, max)

              {coordinate, new_actual}
            end)

          Common.distance(position, bot) < bot.radius
        end)

      Map.put(box, :count, count)
    end

    defp coordinate(position, low, high)
         when abs(low - position) < abs(high - position) and position < low,
         do: low

    defp coordinate(position, low, high) when abs(low - position) < abs(high - position),
      do: position

    defp coordinate(position, _, high) when position > high, do: high
    defp coordinate(position, _, _), do: position
  end
end
