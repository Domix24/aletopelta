defmodule Aletopelta.Year2019.Day03 do
  @moduledoc """
  Day 3 of Year 2019
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 3
    """

    @type input() :: list(binary())
    @type point() :: {integer(), integer()}

    defmodule Segment do
      @moduledoc """
      Segment
      """
      defstruct [:x, :y, :from, :to]

      @type t() :: %__MODULE__{
              x: Range.t(),
              y: Range.t(),
              from: Common.point(),
              to: Common.point()
            }

      defmacrop horizontal?(segment) do
        quote do: unquote(segment).y.first == unquote(segment).y.last
      end

      defmacrop vertical?(segment) do
        quote do: unquote(segment).x.first == unquote(segment).x.last
      end

      @spec intersect(Segment.t(), Segment.t()) :: {integer(), integer()}
      def intersect(segment1, segment2) when horizontal?(segment1) and horizontal?(segment2),
        do: {0, 0}

      def intersect(segment1, segment2) when vertical?(segment1) and vertical?(segment2),
        do: {0, 0}

      def intersect(segment1, segment2) when vertical?(segment1),
        do: intersect(segment1, segment2, :priv)

      def intersect(segment1, segment2), do: intersect(segment2, segment1, :priv)

      defp intersect(
             %{x: min1_x.._//1, y: min1_y..max1_y//1},
             %{x: min2_x..max2_x//1, y: min2_y.._//1},
             :priv
           )
           when min2_x <= min1_x and min1_x <= max2_x and min1_y <= min2_y and min2_y <= max1_y,
           do: {min1_x, min2_y}

      defp intersect(_, _, :priv), do: {0, 0}

      @spec create(Common.point(), Common.point()) :: Segment.t()
      def create({x1, y1} = point1, {x2, y2} = point2) do
        min_x = min(x1, x2)
        min_y = min(y1, y2)

        max_x = max(x1, x2)
        max_y = max(y1, y2)

        %Segment{x: min_x..max_x//1, y: min_y..max_y//1, from: point1, to: point2}
      end
    end

    @spec parse_input(input()) :: list(list(Segment.t()))
    def parse_input(input) do
      Enum.map(input, fn wire ->
        wire
        |> String.split(",")
        |> build_wire()
      end)
    end

    defp get_next(string, direction, point) when is_binary(string),
      do:
        string
        |> String.to_integer()
        |> get_next(direction, point)

    defp get_next(number, ?R, {x, y}), do: {x + number, y}
    defp get_next(number, ?L, {x, y}), do: {x - number, y}
    defp get_next(number, ?U, {x, y}), do: {x, y + number}
    defp get_next(number, ?D, {x, y}), do: {x, y - number}

    defp build_wire(directions, last_point \\ {0, 0}, wire \\ [])
    defp build_wire([], _, wire), do: wire

    defp build_wire([<<direction::utf8, string::binary>> | rest], last_point, wire) do
      next_point = get_next(string, direction, last_point)
      segment = Segment.create(last_point, next_point)
      build_wire(rest, next_point, [segment | wire])
    end

    @spec distance(point(), point()) :: integer()
    def distance({x1, y1}, {x2, y2} \\ {0, 0}), do: abs(y2 - y1) + abs(x2 - x1)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 3
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> combine()
      |> Enum.reject(&(&1 == {0, 0}))
      |> Enum.min_by(&Common.distance/1)
      |> Common.distance()
    end

    defp combine([list1, list2]) do
      for one <- list1, two <- list2, do: Common.Segment.intersect(one, two)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 3
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Enum.map(&Enum.reverse(&1))
      |> combine()
      |> Enum.reject(&(elem(&1, 0) == {0, 0}))
      |> Enum.min_by(&travel/1)
      |> travel()
    end

    defp combine(lists) do
      [listdistance1, listdistance2] = Enum.map(lists, &map_distance/1)

      for {one, distance_one} <- listdistance1, {two, distance_two} <- listdistance2 do
        {Common.Segment.intersect(one, two), one.from, two.from, distance_one, distance_two}
      end
    end

    defp map_distance(list) do
      list
      |> Enum.map_reduce(0, fn %{x: range_x, y: range_y} = segment, acc_distance ->
        {{segment, acc_distance}, acc_distance + Range.size(range_x) + Range.size(range_y) - 2}
      end)
      |> elem(0)
    end

    defp travel({point, from1, from2, distance1, distance2}) do
      distance1 + distance2 + Common.distance(point, from1) + Common.distance(point, from2)
    end
  end
end
