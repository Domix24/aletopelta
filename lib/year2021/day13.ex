defmodule Aletopelta.Year2021.Day13 do
  @moduledoc """
  Day 13 of Year 2021
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 13
    """

    @type input() :: [binary()]
    @type coords() :: [{integer(), integer()}]
    @type folds() :: [{:x | :y, integer()}]

    @spec parse_input(input()) :: {coords(), folds()}
    def parse_input(input) do
      {coords, ["" | folds]} = Enum.split_while(input, &(&1 !== ""))

      new_coords =
        Enum.map(coords, fn coord ->
          [x, y] =
            coord
            |> String.split(",")
            |> Enum.map(&String.to_integer/1)

          {x, y}
        end)

      new_folds =
        Enum.map(folds, fn fold ->
          ~r/([x|y])=(\d+)/
          |> Regex.scan(fold)
          |> convert_fold()
        end)

      {new_coords, new_folds}
    end

    defp convert_fold([[_, "y", number]]), do: {:y, String.to_integer(number)}
    defp convert_fold([[_, "x", number]]), do: {:x, String.to_integer(number)}

    @spec do_fold(coords(), folds()) :: coords()
    def do_fold(coords, []), do: coords

    def do_fold(coords, [{type, fold} | folds]) do
      coords
      |> Enum.map(&map_coord(type, &1, fold))
      |> Enum.uniq()
      |> do_fold(folds)
    end

    defp map_coord(:y, {x, y}, fold) when y > fold, do: {x, fold + fold - y}
    defp map_coord(:x, {x, y}, fold) when x > fold, do: {fold + fold - x, y}
    defp map_coord(_, coord, _), do: coord
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 13
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> do_fold()
      |> Enum.count()
    end

    defp do_fold({coords, [fold | _]}), do: Common.do_fold(coords, [fold])
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 13
    """
    @spec execute(Common.input(), []) :: [binary()]
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> do_fold()
      |> display()
      |> Enum.map(&Enum.join/1)
    end

    defp do_fold({coords, folds}), do: Common.do_fold(coords, folds)

    defp display(coords) do
      {{min_x, _}, {max_x, _}} = Enum.min_max_by(coords, &elem(&1, 0))
      {{_, min_y}, {_, max_y}} = Enum.min_max_by(coords, &elem(&1, 1))

      for y <- min_y..max_y do
        for x <- min_x..max_x do
          if Enum.member?(coords, {x, y}) do
            "#"
          else
            "."
          end
        end
      end
    end
  end
end
