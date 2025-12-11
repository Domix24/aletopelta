defmodule Aletopelta.Year2025.Day11 do
  @moduledoc """
  Day 11 of Year 2025
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 11
    """

    @type input() :: list(binary())
    @type output() :: integer()
    @type passby() :: {boolean(), boolean()}
    @type memo() :: %{{passby(), binary()} => integer()}
    @type schema() :: %{binary() => list(binary())}

    @spec parse_input(input()) :: schema()
    def parse_input(input) do
      Map.new(input, fn line ->
        [source | targets] = String.split(line, ~r"[\s:]+")
        {source, targets}
      end)
    end

    @spec start_explore(schema(), binary(), passby(), memo()) :: {integer(), memo()}
    def start_explore(map, node \\ "you", passby \\ {true, true}, memo \\ Map.new()),
      do:
        map
        |> Map.fetch!(node)
        |> Enum.reduce({0, memo}, fn node, {acc_total, acc_memo} ->
          {total, submemo} = do_explore(node, passby, acc_memo, map)
          {total + acc_total, submemo}
        end)

    defp do_explore("out", {true, true}, memo, _), do: {1, memo}
    defp do_explore("out", _, memo, _), do: {0, memo}

    defp do_explore(node, {dac, fft}, memo, map) do
      new_dac = dac || node === "dac"
      new_fft = fft || node === "fft"
      new_passby = {new_dac, new_fft}
      key = {new_passby, node}

      case Map.get(memo, key) do
        nil ->
          {total, sub_memo} = start_explore(map, node, new_passby, memo)
          {total, Map.put(sub_memo, key, total)}

        total ->
          {total, memo}
      end
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 11
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.start_explore()
      |> elem(0)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 11
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.start_explore("svr", {false, false})
      |> elem(0)
    end
  end
end
