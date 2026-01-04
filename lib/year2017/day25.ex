defmodule Aletopelta.Year2017.Day25 do
  @moduledoc """
  Day 25 of Year 2017
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 25
    """

    @type input() :: list(binary())
    @type output() :: integer()

    @spec parse_input(input()) ::
            {atom(), integer(), %{atom() => %{integer() => {integer(), :left | :right, atom()}}}}
    def parse_input(input) do
      {[begin_string, diagnostic_string, ""], rest} = Enum.split(input, 3)

      begin = last_word(begin_string)
      diagnostic = to_number(diagnostic_string)

      parsed =
        rest
        |> Enum.chunk_by(&(&1 === ""))
        |> Enum.reject(&(&1 === [""]))
        |> Map.new(&parse_chunk/1)

      {begin, diagnostic, parsed}
    end

    defp to_number(string),
      do:
        ~r"\d+"
        |> Regex.run(string)
        |> Enum.at(0)
        |> String.to_integer()

    defp last_word(string),
      do:
        ~r"\w+"
        |> Regex.scan(string)
        |> Enum.take(-1)
        |> Enum.flat_map(&~w"#{&1}"a)
        |> Enum.at(0)

    defp parse_chunk([head_string | chunk]) do
      head = last_word(head_string)

      zeroone =
        chunk
        |> Enum.with_index(&{rem(&2, 4), &1})
        |> Enum.map(&parse_line/1)
        |> Enum.chunk_every(4)
        |> Map.new(fn [value, new_value, move, state] -> {value, {new_value, move, state}} end)

      {head, zeroone}
    end

    defp parse_line({index, line}) when index in 0..1, do: to_number(line)
    defp parse_line({index, line}) when index in 2..3, do: last_word(line)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 25
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> do_loop()
    end

    defp do_loop({state, steps, rules}),
      do:
        {Map.new(), 0, state}
        |> Stream.iterate(&iterate(&1, rules))
        |> Enum.at(steps)
        |> elem(0)
        |> Enum.sum_by(&elem(&1, 1))

    defp iterate({tape, position, state}, rules) do
      current = Map.get(tape, position, 0)
      %{^current => {value, movement, new_state}} = Map.fetch!(rules, state)

      new_tape = Map.put(tape, position, value)

      {new_tape, move(position, movement), new_state}
    end

    defp move(position, :right), do: position - 1
    defp move(position, :left), do: position + 1
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 25
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      Common.parse_input(input)
      0
    end
  end
end
