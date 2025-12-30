defmodule Aletopelta.Year2017.Day10 do
  @moduledoc """
  Day 10 of Year 2017
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 10
    """

    @type input() :: list(binary())
    @type output() :: none()

    @spec parse_input(input()) :: list(integer())
    def parse_input(input) do
      input
      |> Enum.at(0)
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
    end

    @spec do_round(list(integer()) | Range.t(), list(integer()), integer(), integer()) ::
            {list(integer()), integer(), integer()}
    def do_round(list, lengths, position, skip) do
      Enum.reduce(lengths, {list, position, skip}, fn length, {list, position, skip} ->
        new_list =
          list
          |> Enum.split(position)
          |> build_list(length)

        new_position = rem(position + length + skip, 256)

        {new_list, new_position, skip + 1}
      end)
    end

    defp build_list({left, rest}, length) when length(rest) >= length do
      {operation, right} = Enum.split(rest, length)

      left ++ Enum.reverse(operation) ++ right
    end

    defp build_list({left, rest}, length) do
      rest_length = length(rest)
      operation_length = length - rest_length

      {temp_left, new_rest} = Enum.split(left, operation_length)

      {new_left, new_right} =
        (rest ++ temp_left)
        |> Enum.reverse()
        |> Enum.split(rest_length)

      new_right ++ new_rest ++ new_left
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 10
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> do_loop()
    end

    defp do_loop(lengths),
      do:
        0..255
        |> Common.do_round(lengths, 0, 0)
        |> elem(0)
        |> Enum.take(2)
        |> Enum.product()
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 10
    """
    @spec execute(Common.input(), []) :: binary()
    def execute(input, _) do
      input
      |> parse()
      |> do_rounds()
      |> String.downcase()
    end

    defp do_rounds(lengths),
      do:
        1..64
        |> Enum.reduce({0..255, 0, 0}, fn _, {list, position, skip} ->
          Common.do_round(list, lengths, position, skip)
        end)
        |> elem(0)
        |> Enum.chunk_every(16)
        |> Enum.map_join(fn chunk ->
          chunk
          |> Enum.reduce(&Bitwise.bxor/2)
          |> Integer.to_string(16)
          |> String.pad_leading(2, "0")
        end)

    defp parse([input]),
      do:
        input
        |> String.to_charlist()
        |> Enum.concat([17, 31, 73, 47, 23])
  end
end
