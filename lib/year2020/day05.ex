defmodule Aletopelta.Year2020.Day05 do
  @moduledoc """
  Day 5 of Year 2020
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 5
    """

    @type input() :: list(binary())

    @spec parse_input(input()) :: list(list(binary()))
    def parse_input(input) do
      Enum.map(input, &String.graphemes/1)
    end

    @spec get_id(list(binary())) :: keyword()
    def get_id(pass) do
      {row, rest} = get_part(pass, 0, 127)
      {column, _} = get_part(rest, 0, 7)

      [row: row, column: column, seat: row * 8 + column]
    end

    defp get_part(rest, number, number), do: {number, rest}

    defp get_part([p | rest], min, max) when p in ["B", "R"] do
      change = div(max - min, 2)
      get_part(rest, max - change, max)
    end

    defp get_part([p | rest], min, max) when p in ["F", "L"] do
      change = div(max - min, 2)
      get_part(rest, min, min + change)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 5
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Enum.map(&Common.get_id/1)
      |> Enum.max_by(&Keyword.get(&1, :seat))
      |> Keyword.get(:seat)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 5
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Enum.map(&Common.get_id/1)
      |> Enum.group_by(&Keyword.get(&1, :row))
      |> Enum.sort_by(&elem(&1, 0))
      |> Enum.drop(-1)
      |> Enum.reject(fn {_, seats} -> Enum.count(seats) == 8 end)
      |> find_seat()
    end

    defp find_seat(pass) do
      pass
      |> Enum.flat_map(&elem(&1, 1))
      |> Enum.sort_by(&Keyword.get(&1, :column))
      |> Enum.reduce_while({-1, nil}, &find_missing/2)
      |> parse_result()
    end

    defp find_missing(pass, {last, _}) do
      column = Keyword.get(pass, :column)

      if column - 1 == last do
        {:cont, {column, Keyword.get(pass, :seat)}}
      else
        {:halt, {Keyword.get(pass, :seat) - 1, nil}}
      end
    end

    defp parse_result({seat, nil}), do: seat
    defp parse_result({_, seat}), do: seat - 1
  end
end
