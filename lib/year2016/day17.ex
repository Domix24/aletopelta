defmodule Aletopelta.Year2016.Day17 do
  @moduledoc """
  Day 17 of Year 2016
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 17
    """

    @type input() :: list(binary())
    @type output() :: none()

    @spec parse_input(input()) :: binary()
    def parse_input(input) do
      Enum.at(input, 0)
    end

    @spec search(binary(), module()) :: binary() | integer()
    def search(salt, part) do
      part_string =
        "#{part}"
        |> String.split(".")
        |> Enum.take(-1)
        |> Enum.at(0)
        |> String.downcase()

      [new_part] = ~w"#{part_string}"a

      search([{0, 0, ""}], [], {3, 3}, salt, new_part, 0, 0)
    end

    defp search([], [], _, _, :part2, _, vault), do: vault

    defp search([], list, goal, salt, part, steps, vault),
      do: search(list, [], goal, salt, part, steps + 1, vault)

    defp search([node | rest], list, goal, salt, part, steps, vault) do
      case check(node, goal, part) do
        :final ->
          elem(node, 2)

        :vault ->
          search(rest, list, goal, salt, part, steps, steps)

        :new ->
          new_list = next(node, salt) ++ list

          search(rest, new_list, goal, salt, part, steps, vault)
      end
    end

    defp convert(""), do: []
    defp convert(<<character, rest::binary>>), do: [state(character) | convert(rest)]

    defp state(character) when character in ?B..?F, do: :open
    defp state(_), do: :closed

    defp next({x, y, taken}, salt),
      do:
        :md5
        |> :crypto.hash([salt, taken])
        |> Base.encode16()
        |> String.slice(0, 4)
        |> convert()
        |> Enum.zip([{x, y - 1, "U"}, {x, y + 1, "D"}, {x - 1, y, "L"}, {x + 1, y, "R"}])
        |> Enum.filter(&valid?/1)
        |> Enum.map(fn {:open, {x, y, d}} -> {x, y, "#{taken}#{d}"} end)

    defp valid?({:closed, _}), do: false
    defp valid?({:open, {x, y, _}}), do: x in 0..3 and y in 0..3

    defp check({x, y, _}, {x, y}, part), do: win(part)
    defp check(_, _, _), do: :new

    defp win(:part1), do: :final
    defp win(:part2), do: :vault
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 17
    """
    @spec execute(Common.input(), []) :: binary()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.search(__MODULE__)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 17
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.search(__MODULE__)
    end
  end
end
