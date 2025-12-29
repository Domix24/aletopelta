defmodule Aletopelta.Year2017.Day05 do
  @moduledoc """
  Day 5 of Year 2017
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 5
    """

    @type input() :: list(binary())
    @type output() :: integer()

    @spec parse_input(input()) :: %{integer() => integer()}
    def parse_input(input) do
      input
      |> Enum.with_index(&{&2, String.to_integer(&1)})
      |> Map.new()
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 5
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> process()
    end

    defp process(cpu, pointer \\ 0, steps \\ 0) do
      case Map.get(cpu, pointer) do
        nil ->
          steps

        next ->
          cpu
          |> Map.put(pointer, next + 1)
          |> process(pointer + next, steps + 1)
      end
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 5
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> process()
    end

    defp process(cpu, pointer \\ 0, steps \\ 0) do
      case Map.get(cpu, pointer) do
        nil ->
          steps

        next ->
          cpu
          |> Map.put(pointer, offset(next))
          |> process(pointer + next, steps + 1)
      end
    end

    defp offset(number) when number > 2, do: number - 1
    defp offset(number), do: number + 1
  end
end
