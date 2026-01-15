defmodule Aletopelta.Year2015.Day06 do
  @moduledoc """
  Day 6 of Year 2015
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 6
    """

    @type input() :: list(binary())
    @type output() :: integer()
    @type range() :: {integer(), integer()}
    @type action() :: {:turn, :on | :off} | :toggle
    @type instruction() :: {action(), range(), range()}
    @type value() :: :on | :off | integer()
    @type complex() :: {action(), value()} | value()

    @spec parse_input(input()) :: list(instruction())
    def parse_input(input) do
      Enum.map(input, fn line ->
        case String.split(line) do
          [_, state, position1, _, position2] ->
            {{:turn, Enum.at(~w"#{state}"a, 0)}, extract(position1), extract(position2)}

          [_, position1, _, position2] ->
            {:toggle, extract(position1), extract(position2)}
        end
      end)
    end

    defp extract([x, y]), do: {x, y}

    defp extract(position),
      do:
        position
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)
        |> extract()

    @spec execute(list(instruction()), (action() -> value()), (complex(), complex() -> value())) ::
            list({Range.t(), value()})
    def execute(instructions, initial, update),
      do:
        instructions
        |> Enum.reduce(Map.new(), fn {action, {x1, y1}, {x2, y2}}, grid ->
          Enum.reduce(y1..y2, grid, &update_grid(&2, &1, {x1, x2}, action, {initial, update}))
        end)
        |> Enum.flat_map(&elem(&1, 1))

    defp update_grid(grid, y, {x1, x2}, action, {initial, update}) do
      Map.update(grid, y, [{x1..x2, initial.(action)}], fn old_list ->
        [{x1..x2, {action, initial.(action)}} | old_list]
        |> Enum.sort_by(fn {first..last//1, _} -> {first, last} end)
        |> reconstruct(update)
      end)
    end

    defp reconstruct([{range, value}], _), do: [{range, clean(value)}]

    defp reconstruct([{x1..x2//1, v1}, {x3..x4//1, v2} | rest], update)
         when x1 < x3 and x2 < x4 and x2 < x3,
         do: precombine([{x1..x2//1, clean(v1)}, {x3..x4//1, v2}], rest, update)

    defp reconstruct([{x1..x2//1, v1}, {x3..x4//1, v2} | rest], update) when x1 < x3 and x4 < x2,
      do:
        precombine(
          [{x1..(x3 - 1)//1, clean(v1)}, {x3..x4//1, update.(v1, v2)}, {(x4 + 1)..x2//1, v1}],
          rest,
          update
        )

    defp reconstruct([{x1..x2//1, v1}, {x3..x4//1, v2} | rest], update)
         when x1 < x3 and x2 < x4 and x3 < x2,
         do:
           precombine(
             [{x1..(x3 - 1)//1, clean(v1)}, {x3..x2//1, update.(v1, v2)}, {(x2 + 1)..x4//1, v2}],
             rest,
             update
           )

    defp reconstruct([{x1..x2//1, v1}, {x1..x4//1, v2} | rest], update)
         when x1 < x2 and x1 < x4 and x2 < x4,
         do: precombine([{x1..x2//1, update.(v1, v2)}, {(x2 + 1)..x4//1, v2}], rest, update)

    defp reconstruct([{x1..x2//1, v1}, {x3..x2//1, v2} | rest], update)
         when x1 < x2 and x3 < x2 and x1 < x3,
         do:
           precombine([{x1..(x3 - 1)//1, clean(v1)}, {x3..x2//1, update.(v1, v2)}], rest, update)

    defp reconstruct([{x1..x1//1, v1}, {x1..x2//1, v2} | rest], update) when x1 < x2,
      do: precombine([{x1..x1//1, update.(v1, v2)}, {(x1 + 1)..x2//1, v2}], rest, update)

    defp reconstruct([{x1..x2//1, v1}, {x2..x3//1, v2} | rest], update) when x1 < x2 and x1 < x3,
      do:
        precombine(
          [{x1..(x2 - 1)//1, clean(v1)}, {x2..x2//1, update.(v1, v2)}, {(x2 + 1)..x3//1, v2}],
          rest,
          update
        )

    defp reconstruct([{x1..x2//1, v1}, {x1..x2//1, v2} | rest], update) when x1 < x2,
      do: precombine([{x1..x2//1, update.(v1, v2)}], rest, update)

    defp reconstruct([{x1..x1//1, v1}, {x1..x1//1, v2} | rest], update),
      do: precombine([{x1..x1//1, update.(v1, v2)}], rest, update)

    defp reconstruct([a, b | rest], update) when a > b, do: reconstruct([b, a | rest], update)

    defp precombine(list, rest, update),
      do:
        list
        |> combine()
        |> postcombine(rest, update)

    defp postcombine([a], rest, update), do: reconstruct([a | rest], update)
    defp postcombine([a, b], rest, update), do: [a | reconstruct([b | rest], update)]
    defp postcombine([a, b, c], rest, update), do: [a | reconstruct([b, c | rest], update)]

    defp combine({x1..x2//1, value}, {x3..x4//1, value})
         when x1 < x2 and x3 < x4 and x2 + 1 == x3, do: [{x1..x4//1, value}]

    defp combine({x1..x2//1, value}, {x1..x3//1, value}) when x1 < x2 and x1 < x3 and x2 < x3,
      do: [{x1..x3//1, value}]

    defp combine({x1..x3//1, value}, {x2..x3//1, value}) when x1 < x3 and x2 < x3 and x1 < x2,
      do: [{x1..x3//1, value}]

    defp combine({x1..x2//1, _} = f1, {x3..x4//1, _} = f2) when x1 <= x2 and x2 < x3 and x3 <= x4,
      do: [f1, f2]

    defp combine([_] = list), do: list

    defp combine([a, b | c]) do
      case combine(a, b) do
        [d] -> combine([d | c])
        [_, _] -> [a | combine([b | c])]
      end
    end

    defp clean({_, value}), do: value
    defp clean(value), do: value
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 6
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.execute(&initial/1, &update/2)
      |> Enum.filter(&(elem(&1, 1) === :on))
      |> Enum.sum_by(fn {range, _} -> Range.size(range) end)
    end

    defp initial({:turn, state}), do: state
    defp initial(:toggle), do: :on

    defp update({:toggle, _}, state), do: toggle(state)
    defp update(state, {:toggle, _}), do: toggle(state)

    defp update({{:turn, state}, _}, _), do: state
    defp update(_, {{:turn, state}, _}), do: state

    defp toggle(:on), do: :off
    defp toggle(:off), do: :on
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 6
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.execute(&initial/1, &update/2)
      |> Enum.sum_by(fn {range, value} -> Range.size(range) * value end)
    end

    defp initial({:turn, :on}), do: 1
    defp initial({:turn, :off}), do: 0
    defp initial(:toggle), do: 2

    defp update({:toggle, _}, state), do: state + 2
    defp update(state, {:toggle, _}), do: state + 2

    defp update({{:turn, :on}, _}, state), do: state + 1
    defp update(state, {{:turn, :on}, _}), do: state + 1

    defp update({{:turn, :off}, _}, state), do: max(0, state - 1)
    defp update(state, {{:turn, :off}, _}), do: max(0, state - 1)
  end
end
