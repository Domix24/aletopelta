defmodule Aletopelta.Year2017.Knot do
  @moduledoc """
  Knot
  """

  @type hash() :: binary()
  @type input() :: list(integer())

  @spec new(input()) :: hash()
  def new(input),
    do:
      input
      |> prepare()
      |> hash()

  defp prepare(input), do: Enum.concat(input, [17, 31, 73, 47, 23])

  @spec parse(binary()) :: input()
  def parse(input), do: String.to_charlist(input)

  defp hash(lengths),
    do:
      1..64
      |> Enum.reduce({0..255, 0, 0}, fn _, {list, position, skip} ->
        hash(list, lengths, position, skip)
      end)
      |> elem(0)
      |> Enum.chunk_every(16)
      |> Enum.map_join(fn chunk ->
        chunk
        |> Enum.reduce(&Bitwise.bxor/2)
        |> Integer.to_string(16)
        |> String.pad_leading(2, "0")
      end)

  @spec raw(input()) :: input()
  def raw(lengths),
    do:
      0..255
      |> hash(lengths, 0, 0)
      |> elem(0)

  defp hash(list, lengths, position, skip),
    do:
      Enum.reduce(lengths, {list, position, skip}, fn length, {list, position, skip} ->
        new_list =
          list
          |> Enum.split(position)
          |> build(length)

        new_position = rem(position + length + skip, 256)

        {new_list, new_position, skip + 1}
      end)

  defp build({left, rest}, length) when length(rest) >= length do
    {operation, right} = Enum.split(rest, length)

    left ++ Enum.reverse(operation) ++ right
  end

  defp build({left, rest}, length) do
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
