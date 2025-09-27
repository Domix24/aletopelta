defmodule Aletopelta.Year2018.Day12 do
  @moduledoc """
  Day 12 of Year 2018
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 12
    """

    @type input() :: list(binary())

    @spec parse_input(input()) :: {list(binary()), %{binary() => binary()}}
    def parse_input(input) do
      input
      |> Enum.flat_map(fn line ->
        ~r"[#.]+"
        |> Regex.scan(line)
        |> then(fn
          [state] -> state
          [] -> []
          [[part1], [part2]] -> [{part1, part2}]
        end)
      end)
      |> then(fn [initial | rest] ->
        {String.graphemes(initial), Map.new(rest)}
      end)
    end

    @spec start_loop({list(binary()), %{binary() => binary()}}, integer()) ::
            {integer(), integer(), integer()} | integer()
    def start_loop({initial, grid}, count),
      do:
        initial
        |> Enum.with_index()
        |> do_loop(0, grid, count, nil)

    defp do_loop(_, max, _, max, {_, sum, _, _}), do: sum

    defp do_loop(state, generation, mapping, max, last),
      do:
        state
        |> process_state(mapping)
        |> trim_start()
        |> Enum.reverse()
        |> trim_start()
        |> Enum.reverse()
        |> next_state(generation + 1, mapping, max, last)

    defp next_state(state, generation, mapping, max, last) do
      state
      |> Enum.filter(&(elem(&1, 0) === "#"))
      |> Enum.sum_by(&elem(&1, 1))
      |> process_last(last, {state, generation, mapping, max})
    end

    defp process_last(current, nil, {state, generation, mapping, max}),
      do: do_loop(state, generation, mapping, max, {generation, current, nil, 0})

    defp process_last(
           current,
           {last_generation, last_current, last_difference, last_count},
           {state, generation, mapping, max}
         ) do
      difference = current - last_current

      cond do
        difference === last_difference and last_count > 0 ->
          {current, generation, difference}

        difference === last_difference ->
          do_loop(
            state,
            generation,
            mapping,
            max,
            {last_generation, current, last_difference, last_count + 1}
          )

        true ->
          do_loop(state, generation, mapping, max, {generation, current, difference, 0})
      end
    end

    defp process_state(list, mapping, left \\ [])

    defp process_state([{_, index} | _] = list, mapping, []),
      do: process_state([{".", index - 1} | list], mapping, [{".", index - 3}, {".", index - 2}])

    defp process_state(
           [
             {center, index} = fullcenter,
             {right1, _} = fullright1,
             {right2, _} = fullright2 | rest
           ],
           mapping,
           [{left2, _}, {left1, _} = fullleft1]
         ) do
      new_center = get_note(mapping, left2, left1, center, right1, right2)

      [
        {new_center, index}
        | process_state([fullright1, fullright2 | rest], mapping, [fullleft1, fullcenter])
      ]
    end

    defp process_state([{center, index} = fullcenter, {right1, _} = fullright1], mapping, [
           {left2, _},
           {left1, _} = fullleft1
         ]) do
      new_center = get_note(mapping, left2, left1, center, right1)
      [{new_center, index} | process_state([fullright1], mapping, [fullleft1, fullcenter])]
    end

    defp process_state([{center, index} = fullcenter], mapping, [
           {left2, _},
           {left1, _} = fullleft1
         ]) do
      new_center = get_note(mapping, left2, left1, center)
      [{new_center, index} | process_state([], mapping, [fullleft1, fullcenter])]
    end

    defp process_state([], mapping, [{left2, _}, {left1, index}]) do
      [{get_note(mapping, left2, left1), index + 1}]
    end

    defp get_note(mapping, left2, left1, center \\ ".", right1 \\ ".", right2 \\ "."),
      do: Map.get(mapping, "#{left2}#{left1}#{center}#{right1}#{right2}", ".")

    defp trim_start([{".", _} | state]), do: trim_start(state)
    defp trim_start(state), do: state
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 12
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.start_loop(20)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 12
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.start_loop(50_000_000_000)
      |> sum()
    end

    defp sum({sum, index, difference}), do: (50_000_000_000 - index) * difference + sum
  end
end
