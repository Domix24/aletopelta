defmodule Aletopelta.Year2016.Day16 do
  @moduledoc """
  Day 16 of Year 2016
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 16
    """

    @type input() :: list(binary())
    @type output() :: binary()

    @spec parse_input(input()) :: list(integer())
    def parse_input(input) do
      input
      |> Enum.at(0)
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
    end

    @spec prepare(list(integer()), integer()) :: binary()
    def prepare(initial, disk_length) do
      initial_length = Enum.count(initial)

      reduction_levels = count_factors(disk_length)
      chunk_size = 2 ** reduction_levels
      number_chunks = div(disk_length, chunk_size) - 1

      Enum.map_join(0..number_chunks, fn chunk_index ->
        start_position = chunk_index * chunk_size
        parity = range_parity(initial, initial_length, start_position, chunk_size)

        1 - rem(parity, 2)
      end)
    end

    defp count_factors(n), do: count_factors(n, 0)

    defp count_factors(n, acc) when rem(n, 2) === 1, do: acc
    defp count_factors(n, acc), do: count_factors(div(n, 2), acc + 1)

    defp range_parity(initial, initial_length, start, length) do
      generation_length = find_length(initial_length, start + length - 1)
      range_parity(initial, initial_length, start, length, generation_length)
    end

    defp range_parity(initial, initial_length, start, length, _)
         when start + length < initial_length + 1,
         do:
           initial
           |> Enum.take(start + length)
           |> Enum.take(-length)
           |> Enum.sum()

    defp range_parity(initial, initial_length, start, length, generation_length) do
      half_length = div(generation_length - 1, 2)
      middle = half_length

      parity = 0
      range_end = start + length

      left_parity =
        if start < half_length do
          left_end = min(range_end, half_length)
          left_length = left_end - start

          if left_length > 0 do
            parity + range_parity(initial, initial_length, start, left_length, half_length)
          else
            parity
          end
        else
          parity
        end

      if range_end > middle + 1 do
        right_start = max(start, middle + 1)
        right_end = range_end
        right_length = right_end - right_start

        if right_length > 0 do
          mirror_start = generation_length - right_end
          mirror_length = right_length

          mirrored_parity =
            range_parity(initial, initial_length, mirror_start, mirror_length, half_length)

          flipped_parity = right_length - mirrored_parity
          left_parity + flipped_parity
        else
          left_parity
        end
      else
        left_parity
      end
    end

    defp find_length(length, position) when position < length, do: length
    defp find_length(length, position), do: find_length(length * 2 + 1, position)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 16
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.prepare(272)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 16
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.prepare(35_651_584)
    end
  end
end
