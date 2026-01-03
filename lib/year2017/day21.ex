defmodule Aletopelta.Year2017.Day21 do
  @moduledoc """
  Day 21 of Year 2017
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 21
    """

    @type input() :: list(binary())
    @type output() :: integer()
    @type book() :: list(list(binary()))
    @type pattern() :: list(binary())

    @spec parse_input(input()) :: book()
    def parse_input(input) do
      Enum.map(input, fn line ->
        ~r"[#./]+"
        |> Regex.scan(line)
        |> Enum.map(fn [line] ->
          line
          |> String.split("/")
          |> Enum.map(&String.graphemes/1)
        end)
      end)
    end

    @spec pattern() :: list(list(binary()))
    def pattern, do: [[".", "#", "."], [".", ".", "#"], ["#", "#", "#"]]

    @spec look_pattern(pattern(), book(), integer()) :: pattern() | nil
    def look_pattern(pattern, book, transform),
      do:
        pattern
        |> transform(transform)
        |> find_pattern(book, transform)

    defp transform(pattern, 0), do: pattern
    defp transform(pattern, 4), do: flip(pattern)
    defp transform(pattern, i) when i in 1..7, do: rotate(pattern)

    defp flip(pattern), do: Enum.map(pattern, &Enum.reverse/1)

    defp rotate(pattern),
      do:
        pattern
        |> Enum.reverse()
        |> Enum.zip_with(& &1)

    defp find_pattern(pattern, book, transform),
      do:
        pattern
        |> find_pattern(book)
        |> next_find(book, pattern, transform)

    defp find_pattern(pattern, book),
      do:
        Enum.find_value(book, fn
          [^pattern, output] -> output
          _ -> nil
        end)

    defp next_find(nil, book, pattern, transform), do: look_pattern(pattern, book, transform + 1)
    defp next_find(output, _, _, _), do: output

    @spec iterate(book(), pattern()) :: {list(pattern()) | nil, pattern()}
    def iterate(book, pattern), do: iterate(book, pattern, length(pattern))

    defp iterate(book, pattern, length) when length in 2..3,
      do: {nil, look_pattern(pattern, book, 0)}

    defp iterate(book, pattern, length) when rem(length, 2) === 0,
      do: look_shape(book, pattern, div(length, 2), 2)

    defp iterate(book, pattern, length) when rem(length, 3) === 0,
      do: look_shape(book, pattern, div(length, 3), 3)

    defp look_shape(book, pattern, nb_parts, size),
      do:
        0..(nb_parts * nb_parts - 1)
        |> Enum.map(fn index ->
          pattern
          |> Enum.take((div(index, nb_parts) + 1) * size)
          |> Enum.take(-size)
          |> Enum.map(fn line ->
            line
            |> Enum.take((rem(index, nb_parts) + 1) * size)
            |> Enum.take(-size)
          end)
          |> Common.look_pattern(book, 0)
        end)
        |> split_result(nb_parts)

    defp split_result(result, nb_parts),
      do:
        result
        |> Enum.chunk_every(nb_parts)
        |> Enum.flat_map(fn chunk -> Enum.zip_with(chunk, & &1) end)
        |> Enum.map(&Enum.concat/1)
        |> split(result)

    defp split(big, little), do: {little, big}

    @spec count_on(pattern()) :: integer()
    def count_on(pattern),
      do:
        pattern
        |> Enum.flat_map(& &1)
        |> Enum.count(&(&1 === "#"))
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 21
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> do_loop()
    end

    defp do_loop(book),
      do:
        Common.pattern()
        |> Stream.iterate(&iterate(book, &1))
        |> Enum.at(5)
        |> Common.count_on()

    defp iterate(book, pattern),
      do:
        book
        |> Common.iterate(pattern)
        |> elem(1)
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 21
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> do_loop()
    end

    defp sum({pattern, count}),
      do:
        pattern
        |> Common.count_on()
        |> Kernel.*(count)

    defp do_loop(book),
      do:
        prepare()
        |> Stream.iterate(&iterate(book, &1))
        |> Enum.at(6)
        |> Enum.sum_by(&sum/1)

    defp prepare, do: Enum.frequencies([Common.pattern()])

    defp iterate(book, patterns),
      do:
        Enum.reduce(patterns, Map.new(), fn {pattern, main}, acc ->
          1..3
          |> Enum.reduce({nil, pattern}, fn _, {_, acc} -> Common.iterate(book, acc) end)
          |> elem(0)
          |> Enum.frequencies()
          |> Enum.reduce(acc, fn {pattern, count}, acc ->
            Map.update(acc, pattern, main * count, &(&1 + main * count))
          end)
        end)
  end
end
