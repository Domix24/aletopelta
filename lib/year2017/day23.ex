defmodule Aletopelta.Year2017.Day23 do
  @moduledoc """
  Day 23 of Year 2017
  """
  alias Aletopelta.Year2017.Machine

  defmodule Common do
    @moduledoc """
    Common part for Day 23
    """

    @type input() :: Machine.input()
    @type output() :: integer()

    @spec parse_input(input()) :: Machine.instructions()
    def parse_input(input) do
      Machine.parse(input)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 23
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Machine.new(options: %{operate: &operate/2})
      |> Machine.start()
      |> elem(3)
      |> Map.fetch!(:count)
    end

    defp operate(["mul" | _], options), do: Map.update(options, :count, 1, &(&1 + 1))
    defp operate(_, options), do: options
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 23
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> process()
    end

    defp process(instructions),
      do:
        instructions
        |> Map.put(8, ["jnz", "1", "40"])
        |> Machine.new(registers: Map.new([{"a", 1}]))
        |> Machine.start()
        |> elem(2)
        |> optimize(instructions)

    defp optimize(registers, instructions) do
      mini = Map.fetch!(registers, "b")
      maxi = Map.fetch!(registers, "c")

      step =
        instructions
        |> Map.fetch!(30)
        |> Enum.at(2)
        |> String.to_integer()

      Enum.count(mini..maxi//-step, &composite?/1)
    end

    defp composite?(number), do: Enum.any?(2..div(number, 2), &(rem(number, &1) < 1))
  end
end
