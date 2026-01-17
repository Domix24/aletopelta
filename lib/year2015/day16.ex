defmodule Aletopelta.Year2015.Day16 do
  @moduledoc """
  Day 16 of Year 2015
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 16
    """

    @type input() :: list(binary())
    @type output() :: integer()
    @type aunt() :: %{atom() => integer()}

    @spec parse_input(input()) :: list({output(), aunt()})
    def parse_input(input) do
      Enum.map(input, fn line ->
        [_, index | orest] =
          ~r"\w+"
          |> Regex.scan(line)
          |> Enum.flat_map(&convert/1)

        rest =
          orest
          |> Enum.chunk_every(2)
          |> Map.new(fn [what, amount] -> {what, amount} end)

        {index, rest}
      end)
    end

    defp convert([input]) do
      case Regex.scan(~r"\d+", input) do
        [] -> ~w"#{input}"a
        _ -> [String.to_integer(input)]
      end
    end

    @spec aunt?(aunt()) :: boolean()
    def aunt?(aunt),
      do:
        Map.get(aunt, :children) in [3, nil] and Map.get(aunt, :samoyeds) in [2, nil] and
          Map.get(aunt, :akitas) in [0, nil] and Map.get(aunt, :vizslas) in [0, nil] and
          Map.get(aunt, :cars) in [2, nil] and Map.get(aunt, :perfumes) in [1, nil]
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 16
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Enum.find_value(fn {index, aunt} ->
        aunt? = aunt?(aunt)

        if aunt?, do: index, else: nil
      end)
    end

    defp aunt?(aunt),
      do:
        Common.aunt?(aunt) and Map.get(aunt, :cats) in [7, nil] and
          Map.get(aunt, :pomeranians) in [3, nil] and Map.get(aunt, :goldfish) in [5, nil] and
          Map.get(aunt, :trees) in [3, nil]
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 16
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Enum.find_value(fn {index, aunt} ->
        aunt? = aunt?(aunt)

        if aunt?, do: index, else: nil
      end)
    end

    defp aunt?(aunt),
      do:
        Common.aunt?(aunt) and (Map.get(aunt, :cats) === nil or Map.get(aunt, :cats, 0) > 7) and
          (Map.get(aunt, :pomeranians) === nil or Map.get(aunt, :pomeranians, 0) < 3) and
          (Map.get(aunt, :goldfish) === nil or Map.get(aunt, :goldfish, 0) < 5) and
          (Map.get(aunt, :trees) === nil or Map.get(aunt, :trees, 0) > 3)
  end
end
