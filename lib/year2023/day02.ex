defmodule Aletopelta.Year2023.Day02 do
  @moduledoc """
  Day 2 of Year 2023
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 16
    """
    def parse_input(input) do
      input
      |> Enum.map(fn game ->
        [[_, index, rest]] = Regex.scan(~r/(\d+): (.*)/, game)

        rest =
          rest
          |> String.split("; ")
          |> Enum.map(&String.trim/1)
          |> Enum.map(fn set ->
            String.split(set, ", ")
            |> Enum.map(&String.split(&1, " "))
            |> Keyword.new(&create_keyword/1)
          end)

        %{index: String.to_integer(index), sets: rest}
      end)
    end

    defp create_keyword([number, color]) do
      {String.to_atom(color), String.to_integer(number)}
    end

    def get_max(game) do
      max =
        game
        |> Map.fetch!(:sets)
        |> Enum.reduce(fn set, acc ->
          Keyword.merge(set, acc, fn _, value1, value2 ->
            max(value1, value2)
          end)
        end)

      %{index: Map.fetch!(game, :index), max: max}
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 2
    """
    def execute(input) do
      Common.parse_input(input)
      |> Enum.map(&Common.get_max/1)
      |> Enum.filter(&valid?/1)
      |> Enum.sum_by(&Map.fetch!(&1, :index))
    end

    defp valid?(%{max: max, index: _}) do
      Keyword.fetch!(max, :blue) <= 14 and Keyword.fetch!(max, :green) <= 13 and
        Keyword.fetch!(max, :red) <= 12
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 2
    """
    def execute(input) do
      Common.parse_input(input)
      |> Enum.map(&Common.get_max/1)
      |> Enum.sum_by(&get_power/1)
    end

    defp get_power(%{max: max, index: _}) do
      Enum.reduce(max, 1, fn {_, number}, acc ->
        number * acc
      end)
    end
  end
end
