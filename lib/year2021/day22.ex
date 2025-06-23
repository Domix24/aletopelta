defmodule Aletopelta.Year2021.Day22 do
  @moduledoc """
  Day 22 of Year 2021
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 22
    """

    @type input() :: [binary()]
    @type output() :: [cube()]
    @type cube() :: %{
            active: boolean(),
            x_range: Range.t(),
            y_range: Range.t(),
            z_range: Range.t()
          }

    @spec parse_input(input()) :: output()
    def parse_input(input) do
      Enum.map(input, fn line ->
        [[_, state | numbers]] =
          Regex.scan(
            ~r/^(on|off) x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)$/,
            line
          )

        [x_range, y_range, z_range] =
          numbers
          |> Enum.map(&String.to_integer/1)
          |> Enum.chunk_every(2)
          |> Enum.map(&to_range/1)

        %{active: state == "on", x_range: x_range, y_range: y_range, z_range: z_range}
      end)
    end

    defp to_range([first, last]), do: Range.new(first, last)

    @spec get_volume(output()) :: integer()
    def get_volume([]), do: 0
    def get_volume([%{active: false} | others]), do: get_volume(others)

    def get_volume([%{active: true} = cube | cubes]) do
      overlap = Enum.flat_map(cubes, &get_overlap(cube, &1))

      process_volume(cube) + get_volume(cubes) - get_volume(overlap)
    end

    defp process_volume(%{active: true} = cube) do
      Enum.product_by([cube.x_range, cube.y_range, cube.z_range], &Range.size/1)
    end

    defp get_overlap(main, cube) do
      [overlap_x, overlap_y, overlap_z] =
        Enum.map([:x_range, :y_range, :z_range], fn range ->
          main_first..main_last//1 = Map.fetch!(main, range)
          cube_first..cube_last//1 = Map.fetch!(cube, range)
          %{min: max(main_first, cube_first), max: min(main_last, cube_last)}
        end)

      if overlap_x.min > overlap_x.max or overlap_y.min > overlap_y.max or
           overlap_z.min > overlap_z.max do
        []
      else
        [
          %{
            active: true,
            x_range: overlap_x.min..overlap_x.max,
            y_range: overlap_y.min..overlap_y.max,
            z_range: overlap_z.min..overlap_z.max
          }
        ]
      end
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 22
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Enum.filter(&within_bound?/1)
      |> Common.get_volume()
    end

    defp within_bound?(%{x_range: first..last//1}) when first < -50 or last > 50, do: false
    defp within_bound?(%{y_range: first..last//1}) when first < -50 or last > 50, do: false
    defp within_bound?(%{z_range: first..last//1}) when first < -50 or last > 50, do: false
    defp within_bound?(_), do: true
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 22
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.get_volume()
    end
  end
end
