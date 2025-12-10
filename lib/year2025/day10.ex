defmodule Aletopelta.Year2025.Day10 do
  @moduledoc """
  Day 10 of Year 2025
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 10
    """

    @type input() :: list(binary())
    @type output() :: integer()

    @spec parse_input(input()) :: list({list(integer()), list(list(integer())), list(integer())})
    def parse_input(input) do
      Enum.map(input, fn line ->
        machine =
          ~r"\[([\#\.]+)\]"
          |> Regex.scan(line)
          |> Enum.flat_map(fn [_, symbols] ->
            String.graphemes(symbols)
          end)

        numbers =
          ~r"\(([\d,]+)\)"
          |> Regex.scan(line)
          |> Enum.map(fn [_, numbers] ->
            numbers
            |> String.split(",")
            |> Enum.map(&String.to_integer(&1))
          end)

        joltages =
          ~r"\{([\d,]+)\}"
          |> Regex.scan(line)
          |> Enum.flat_map(fn [_, numbers] ->
            numbers
            |> String.split(",")
            |> Enum.map(&String.to_integer/1)
          end)

        {machine, numbers, joltages}
      end)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 10
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Enum.sum_by(&trick_machine/1)
    end

    defp trick_machine({goal, buttons, _} = _) do
      start = {clear(goal), 0}

      trick_machine({[start], []}, goal, buttons, Map.new())
    end

    defp trick_machine({[], [_ | _] = next_states}, goal, buttons, seen) do
      states = Enum.reverse(next_states)
      trick_machine({states, []}, goal, buttons, seen)
    end

    defp trick_machine({[{state, _} | states], next_states} = complete, goal, buttons, seen) do
      if is_map_key(seen, state) do
        trick_machine({states, next_states}, goal, buttons, seen)
      else
        trick_machine2(complete, goal, buttons, seen)
      end
    end

    defp trick_machine2({[{goal, press} | _], _}, goal, _, _), do: press

    defp trick_machine2({[{state, press} | states], next_states}, goal, buttons, seen) do
      new_seen = Map.put(seen, state, 1)

      new_states = Enum.reduce(buttons, next_states, &reduce(&1, &2, state, press))

      trick_machine({states, new_states}, goal, buttons, new_seen)
    end

    defp reduce(group, acc_states, state, press) do
      new_state =
        Enum.reduce(group, state, fn button, acc_state ->
          Enum.with_index(acc_state, fn
            symbol, ^button -> toggle(symbol)
            symbol, _ -> symbol
          end)
        end)

      [{new_state, press + 1} | acc_states]
    end

    defp clear([]), do: []
    defp clear([_ | rest]), do: ["." | clear(rest)]

    defp toggle("#"), do: "."
    defp toggle("."), do: "#"
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 10
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      Common.parse_input(input)
      0
    end
  end
end
