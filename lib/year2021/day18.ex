defmodule Aletopelta.Year2021.Day18 do
  @moduledoc """
  Day 18 of Year 2021
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 18
    """

    @type input() :: [binary()]
    @type linesnail() :: [%{depth: integer(), number: integer()}]
    @type basesnail() :: {integer(), integer()}

    @spec parse_input(input()) :: [linesnail()]
    def parse_input(input) do
      Enum.map(input, fn line ->
        line
        |> parse_line()
        |> elem(0)
        |> linearize()
      end)
    end

    defp parse_line(<<"[", rest::binary>>) do
      {part1, new_rest1} = parse_line(rest)
      {part2, new_rest2} = parse_line(new_rest1)

      {{part1, part2}, parse_line(new_rest2)}
    end

    defp parse_line(<<sign, rest::binary>>) when sign in ?0..?9, do: {sign - ?0, rest}
    defp parse_line(<<sign, rest::binary>>) when sign in [?,, ?]], do: parse_line(rest)
    defp parse_line({v, ""}), do: {v, ""}
    defp parse_line(v), do: v

    defp linearize(snail), do: linearize(snail, 0 - 1)

    defp linearize({part1, part2}, depth) do
      linearize1 = linearize(part1, depth + 1)
      linearize2 = linearize(part2, depth + 1)

      linearize1 ++ linearize2
    end

    defp linearize(number, depth), do: [%{number: number, depth: depth}]

    @spec pairize(linesnail()) :: basesnail()
    def pairize(snail) do
      {part1, rest} = pairize(snail, 0)
      {part2, _} = pairize(rest, 0)

      {part1, part2}
    end

    defp pairize([%{depth: depth} | _] = snail, last) when last < depth do
      {part1, rest1} = pairize(snail, last + 1)
      {part2, rest2} = pairize(rest1, last + 1)

      {{part1, part2}, rest2}
    end

    defp pairize([%{depth: depth, number: number} | others], depth) do
      {number, others}
    end

    @spec magnitude(basesnail()) :: integer()
    def magnitude({part1, part2}), do: 3 * magnitude(part1) + 2 * magnitude(part2)
    def magnitude(number), do: number

    @spec reduce(linesnail() | {linesnail(), :nochange} | {linesnail(), :change}) :: linesnail()
    def reduce({snail, :nochange}), do: snail
    def reduce({snail, _}), do: reduce(snail)

    def reduce(snail) do
      snail
      |> explode()
      |> split()
      |> reduce()
    end

    defp explode([
           %{depth: 4},
           %{depth: 4, number: number2},
           %{depth: depth3, number: number3} | others
         ]) do
      explode([%{depth: 3, number: 0}, %{depth: depth3, number: number2 + number3} | others])
    end

    defp explode([
           %{depth: depth1, number: number1},
           %{depth: 4, number: number2},
           %{depth: 4, number: number3},
           %{depth: depth4, number: number4} | others
         ]) do
      explode([
        %{depth: depth1, number: number1 + number2},
        %{depth: 3, number: 0},
        %{depth: depth4, number: number3 + number4} | others
      ])
    end

    defp explode([
           %{depth: depth1, number: number1},
           %{depth: 4, number: number2},
           %{depth: 4} | others
         ]) do
      explode([%{depth: depth1, number: number1 + number2}, %{depth: 3, number: 0} | others])
    end

    defp explode([]), do: []
    defp explode([part | others]), do: [part | explode(others)]

    defp split(snail), do: split(snail, :nochange)

    defp split([%{depth: depth, number: number} | others], :nochange) when number > 9 do
      first = div(number, 2)
      second = if first + first == number, do: first, else: first + 1

      {[%{depth: depth + 1, number: first}, %{depth: depth + 1, number: second} | others],
       :change}
    end

    defp split([part | others], :nochange) do
      {list, state} = split(others, :nochange)
      {[part | list], state}
    end

    defp split([], :nochange), do: {[], :nochange}

    @spec increase_depth(linesnail()) :: linesnail()
    def increase_depth([]), do: []

    def increase_depth([%{depth: depth} = snail | snails]) do
      [%{snail | depth: depth + 1} | increase_depth(snails)]
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 18
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> perform()
      |> Common.pairize()
      |> Common.magnitude()
    end

    defp perform([snail1, snail2 | snails]) do
      [snail1, snail2]
      |> Enum.flat_map(&Common.increase_depth/1)
      |> Common.reduce()
      |> perform(snails)
    end

    defp perform(snail, []), do: snail
    defp perform(snail, snails), do: perform([snail | snails])
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 18
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> perform()
    end

    defp perform(snails), do: perform(snails, 0)

    defp perform([], max), do: max

    defp perform([snail | others], max) do
      new_max =
        snail
        |> perform(others, max)
        |> max(max)

      perform(others, new_max)
    end

    defp perform(_, [], max), do: max

    defp perform(snail, [other_snail | others], max) do
      new_max =
        [snail ++ other_snail, other_snail ++ snail]
        |> Enum.map(fn snail ->
          snail
          |> Common.increase_depth()
          |> Common.reduce()
          |> Common.pairize()
          |> Common.magnitude()
        end)
        |> Enum.max()
        |> max(max)

      perform(snail, others, new_max)
    end
  end
end
