defmodule Aletopelta.Year2020.Day04 do
  @moduledoc """
  Day 4 of Year 2020
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 4
    """

    @type input() :: list(binary())

    @spec parse_input(input()) :: list(keyword())
    def parse_input(input) do
      input
      |> Enum.chunk_by(&(&1 == ""))
      |> Enum.reject(&(&1 == [""]))
      |> Enum.map(fn list ->
        list
        |> Enum.join(" ")
        |> String.split(~r/:| /)
        |> Enum.chunk_every(2)
        |> Enum.map(&convert_attribute/1)
        |> Enum.reject(&(elem(&1, 0) == :cid))
      end)
    end

    defp convert_attribute(["eyr", value]), do: {:eyr, value}
    defp convert_attribute(["pid", value]), do: {:pid, value}
    defp convert_attribute(["hcl", value]), do: {:hcl, value}
    defp convert_attribute(["byr", value]), do: {:byr, value}
    defp convert_attribute(["iyr", value]), do: {:iyr, value}
    defp convert_attribute(["ecl", value]), do: {:ecl, value}
    defp convert_attribute(["hgt", value]), do: {:hgt, value}
    defp convert_attribute(["cid", value]), do: {:cid, value}

    @spec valid_passport?(list(keyword())) :: boolean()
    def valid_passport?(passport),
      do:
        passport
        |> Keyword.keys()
        |> Enum.count()
        |> Kernel.==(7)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 4
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Enum.count(&Common.valid_passport?/1)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 4
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Enum.count(&valid_passport?/1)
    end

    defp valid_passport?(passport),
      do:
        passport
        |> Enum.all?(&valid_attribute?/1)
        |> Kernel.and(Common.valid_passport?(passport))

    defp valid_attribute?({:eyr, value}),
      do:
        value
        |> String.to_integer()
        |> Kernel.in(2020..2030)

    defp valid_attribute?({:pid, value}), do: Regex.match?(~r/^[0-9]{9}$/, value)
    defp valid_attribute?({:hcl, value}), do: Regex.match?(~r/^#[0-9a-f]{6}$/, value)

    defp valid_attribute?({:iyr, value}),
      do:
        value
        |> String.to_integer()
        |> Kernel.in(2010..2020)

    defp valid_attribute?({:byr, value}),
      do:
        value
        |> String.to_integer()
        |> Kernel.in(1920..2002)

    defp valid_attribute?({:hgt, value}),
      do:
        ~r/^(\d+)(in|cm)$/
        |> Regex.scan(value)
        |> valid_height?()

    defp valid_attribute?({:ecl, "amb"}), do: true
    defp valid_attribute?({:ecl, "blu"}), do: true
    defp valid_attribute?({:ecl, "brn"}), do: true
    defp valid_attribute?({:ecl, "gry"}), do: true
    defp valid_attribute?({:ecl, "grn"}), do: true
    defp valid_attribute?({:ecl, "hzl"}), do: true
    defp valid_attribute?({:ecl, "oth"}), do: true
    defp valid_attribute?({:ecl, _}), do: false

    defp valid_height?([[_, value, "cm"]]),
      do:
        value
        |> String.to_integer()
        |> Kernel.in(150..193)

    defp valid_height?([[_, value, "in"]]),
      do:
        value
        |> String.to_integer()
        |> Kernel.in(59..76)

    defp valid_height?(_), do: false
  end
end
