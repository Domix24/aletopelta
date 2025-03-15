defmodule Aletopelta.Year2022.Day09 do
  @moduledoc """
  Day 9 of Year 2022
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 9
    """
    @spec parse_input(any()) :: list()
    def parse_input(input) do
      Enum.map(input, fn line ->
        [direction, steps_str] = String.split(line)
        steps = String.to_integer(steps_str)

        {direction, steps}
      end)
    end

    @spec process_move({<<_::8>>, integer()}, {any(), any()}) :: {any(), any()}
    def process_move({direction, steps}, {rope, tail_positions}) do
      delta = get_delta(direction)

      {_, new_rope, new_positions} =
        Enum.reduce(1..steps, {delta, rope, tail_positions}, &move_rope/2)

      {new_rope, new_positions}
    end

    defp move_rope(_, {{dx, dy} = delta, [{head_x, head_y} | knots], tail_positions}) do
      new_head = {head_x + dx, head_y + dy}

      {last_knot, updated_rope} = update_knots([new_head | knots])
      new_positions = MapSet.put(tail_positions, last_knot)

      {delta, updated_rope, new_positions}
    end

    defp update_knots([head]), do: {head, [head]}

    defp update_knots([{head_x, head_y} = head, {tail_x, tail_y} = tail | rest]) do
      {last, rope_parts} =
        if abs(head_x - tail_x) < 2 and abs(head_y - tail_y) < 2 do
          update_knots([tail | rest])
        else
          new_tail = calculate_tail({head_x, tail_x}, {head_y, tail_y})
          update_knots([new_tail | rest])
        end

      {last, [head | rope_parts]}
    end

    defp calculate_tail({head_x, tail_x}, {head_y, tail_y}) do
      x = move_toward(head_x, tail_x)
      y = move_toward(head_y, tail_y)

      {x, y}
    end

    defp move_toward(head, tail) when tail - head == 0, do: tail
    defp move_toward(head, tail), do: tail + div(head - tail, abs(head - tail))

    @spec create_rope(integer()) :: list()
    def create_rope(length) do
      List.duplicate({0, 0}, length)
    end

    defp get_delta("L"), do: {-1, 0}
    defp get_delta("R"), do: {1, 0}
    defp get_delta("D"), do: {0, 1}
    defp get_delta("U"), do: {0, -1}
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 9
    """
    @spec execute(any()) :: non_neg_integer()
    def execute(input) do
      rope = Common.create_rope(2)

      input
      |> Common.parse_input()
      |> Enum.reduce({rope, MapSet.new()}, &Common.process_move/2)
      |> elem(1)
      |> MapSet.size()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 9
    """
    @spec execute(any()) :: non_neg_integer()
    def execute(input) do
      rope = Common.create_rope(10)

      input
      |> Common.parse_input()
      |> Enum.reduce({rope, MapSet.new()}, &Common.process_move/2)
      |> elem(1)
      |> MapSet.size()
    end
  end
end
