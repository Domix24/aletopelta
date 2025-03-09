defmodule Aletopelta.Year2024.Day25 do
  @moduledoc """
  Day 25 of Year 2024
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 25
    """
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 25
    """
    def execute(input) do
      parse_input(input)
      |> to_number
      |> do_pairs
      |> try_keys
      |> Enum.count(&(elem(&1, 2) == 0))
    end

    defp do_pairs({locks, keys}) do
      do_pairs(locks, keys, 1)
      |> Enum.flat_map(& &1)
    end

    defp do_pairs([], _, 1), do: []

    defp do_pairs([lock | locks], keys, 1) do
      [do_pairs(lock, keys, 2) | do_pairs(locks, keys, 1)]
    end

    defp do_pairs(_, [], 2), do: []

    defp do_pairs(lock, [key | keys], 2) do
      [{lock, key} | do_pairs(lock, keys, 2)]
    end

    defp try_keys([{lock, key} | others]),
      do: [{lock, key, Bitwise.band(lock, key)} | try_keys(others)]

    defp try_keys([]), do: []

    defp to_number({locks, keys}) do
      locks = to_number(locks)
      keys = to_number(keys)
      {locks, keys}
    end

    defp to_number([]), do: []

    defp to_number([schema | others]) do
      [schema |> Enum.join() |> to_number | to_number(others)]
    end

    defp to_number("#"), do: 1
    defp to_number("."), do: 0

    defp to_number(chain) do
      String.graphemes(chain)
      |> Enum.reverse()
      |> Enum.map(&to_number/1)
      |> Enum.with_index(fn v, k -> Bitwise.bsl(v, k) end)
      |> Enum.sum()
    end

    defp parse_input(input), do: parse_input(input, [], {[], []})
    defp parse_input([], [], {locks, keys}), do: {locks |> Enum.reverse(), keys |> Enum.reverse()}

    defp parse_input(["#####" = first | others], [], infos),
      do: parse_input(others, {:lock, [first]}, infos)

    defp parse_input(["....." = first | others], [], infos),
      do: parse_input(others, {:key, [first]}, infos)

    defp parse_input([], {:key, current}, {locks, keys}),
      do: parse_input([], [], {locks, [current |> Enum.reverse() | keys]})

    defp parse_input([], {:lock, current}, {locks, keys}),
      do: parse_input([], [], {[current |> Enum.reverse() | locks], keys})

    defp parse_input(["" | others], {:lock, current}, {locks, keys}),
      do: parse_input(others, [], {[current |> Enum.reverse() | locks], keys})

    defp parse_input(["" | others], {:key, current}, {locks, keys}),
      do: parse_input(others, [], {locks, [current |> Enum.reverse() | keys]})

    defp parse_input([first | others], {type, current}, types),
      do: parse_input(others, {type, [first | current]}, types)
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 25
    """
    def execute(_input), do: 0
  end
end
