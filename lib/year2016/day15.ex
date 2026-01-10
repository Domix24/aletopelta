defmodule Aletopelta.Year2016.Day15 do
  @moduledoc """
  Day 15 of Year 2016
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 15
    """

    @type input() :: list(binary())
    @type output() :: integer()

    @spec parse_input(input()) :: list(list(integer()))
    def parse_input(input) do
      Enum.map(input, fn line ->
        ~r"\d+"
        |> Regex.scan(line)
        |> Enum.flat_map(& &1)
        |> Enum.map(&String.to_integer/1)
      end)
    end

    @spec do_loop(list(list(integer()))) :: output()
    def do_loop(disks),
      do:
        disks
        |> Enum.map(&find_congruences/1)
        |> solve()

    defp find_congruences([number, positions, 0, position]) do
      remainder = rem(-position - number, positions)
      new_remainder = rem(remainder + positions, positions)

      {new_remainder, positions}
    end

    defp solve(congruences) do
      product = Enum.reduce(congruences, 1, fn {_, positions}, acc -> acc * positions end)

      congruences
      |> Enum.sum_by(fn {remainder, modulus} ->
        divide = div(product, modulus)
        inverse = mod_inverse(divide, modulus)
        remainder * divide * inverse
      end)
      |> rem(product)
    end

    defp mod_inverse(a, b) do
      {c, _} = gcd(a, b)

      rem(rem(c, b) + b, b)
    end

    defp gcd(_, 0), do: {1, 0}

    defp gcd(a, b) do
      {d, e} = gcd(b, rem(a, b))
      {e, d - div(a, b) * e}
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 15
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.do_loop()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 15
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> upgrade()
      |> Common.do_loop()
    end

    defp upgrade(disks), do: [[7, 11, 0, 0] | disks]
  end
end
