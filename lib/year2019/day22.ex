defmodule Aletopelta.Year2019.Day22 do
  @moduledoc """
  Day 22 of Year 2019
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 22
    """

    @type input() :: list(binary())

    @spec parse_input(input()) ::
            list(%{command: :newstack} | %{command: :increment | :cut, number: integer()})
    def parse_input(input) do
      Enum.map(input, fn line ->
        regex = ~r/(^deal i)|(^(deal w).*\s(\d+)$)|(^(c.*)\s(-?\d+)$)/

        regex
        |> Regex.run(line, capture: :all_but_first)
        |> Enum.reject(&(&1 == ""))
        |> parse_command()
      end)
    end

    defp parse_command(["deal i"]), do: %{command: :newstack}

    defp parse_command([_, "deal w", increment]),
      do: %{command: :increment, number: String.to_integer(increment)}

    defp parse_command([_, "cut", cut]), do: %{command: :cut, number: String.to_integer(cut)}
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 22
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> execute_commands(10_007)
      |> Enum.find_index(&(&1 === 2019))
    end

    defp execute_commands(commands, decksize) do
      Enum.reduce(commands, 0..(decksize - 1), &execute_command(&1, &2, decksize))
    end

    defp execute_command(%{command: :increment, number: number}, actual_deck, decksize),
      do:
        actual_deck
        |> Stream.cycle()
        |> Stream.with_index(fn _, index -> index end)
        |> Stream.transform(nil, fn
          index, _ when rem(index, number) == 0 -> {[rem(index, decksize)], :loop}
          _, acc -> {[], acc}
        end)
        |> Stream.zip(actual_deck)
        |> Enum.sort_by(&elem(&1, 0))
        |> Enum.map(&elem(&1, 1))

    defp execute_command(%{command: :newstack}, actual_deck, _), do: Enum.reverse(actual_deck)

    defp execute_command(%{command: :cut, number: number}, actual_deck, _) do
      actual_deck
      |> Enum.split(number)
      |> then(fn {part2, part1} ->
        Enum.concat(part1, part2)
      end)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 22
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> do_modular(2020, 119_315_717_514_047, 101_741_582_076_661)
    end

    defp do_modular(input, to_find, size, count) do
      {memory0, memory1} =
        input
        |> Enum.reverse()
        |> Enum.reduce({1, 0}, &module_command(&1, &2, size))

      power = modex(memory0, count, size)

      rem(
        power * to_find + memory1 * (power + size - 1) * modex(memory0 - 1, size - 2, size),
        size
      )
    end

    defp module_command(%{command: :cut, number: number}, {memory0, memory1}, size),
      do: modulize({memory0, rem(memory1 + number, size)}, size)

    defp module_command(%{command: :increment, number: number}, {memory0, memory1}, size),
      do:
        number
        |> modex(size - 2, size)
        |> then(fn result ->
          modulize({memory0 * result, memory1 * result}, size)
        end)

    defp module_command(%{command: :newstack}, {memory0, memory1}, size),
      do: modulize({-memory0, -(memory1 + 1)}, size)

    defp modulize({number1, number2}, modulus),
      do: {rem(number1 + modulus, modulus), rem(number2 + modulus, modulus)}

    defp modex(base, exponent, modulus) do
      do_modex(1, base, exponent, modulus)
    end

    defp do_modex(result, _, 0, _), do: result

    defp do_modex(result, base, exponent, modulus) do
      new_result = update_result(result, base, rem(exponent, 2), modulus)
      new_exponent = div(exponent, 2)
      new_base = rem(base * base, modulus)

      do_modex(new_result, new_base, new_exponent, modulus)
    end

    defp update_result(result, base, 1, modulus), do: rem(result * base, modulus)
    defp update_result(result, _, 0, _), do: result
  end
end
