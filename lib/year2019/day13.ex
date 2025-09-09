defmodule Aletopelta.Year2019.Day13 do
  @moduledoc """
  Day 13 of Year 2019
  """
  alias Aletopelta.Year2019.Intcode

  defmodule Common do
    @moduledoc """
    Common part for Day 13
    """

    @type input() :: list(binary())

    @spec parse_input(input()) :: Intcode.intcode()
    def parse_input(input) do
      Intcode.parse(input)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 13
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Intcode.prepare([0])
      |> elem(1)
      |> Enum.chunk_every(3)
      |> Enum.count(fn [type | _] -> type == 2 end)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 13
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> prepare_loop()
    end

    defp prepare_loop(map) do
      intcode = Map.put(map, 0, 2)
      memory = Map.new(program: intcode, index: 0, base: 0)
      do_loop(memory, false, {nil, nil}, [], 0)
    end

    defp do_loop(_, true, _, _, score), do: score

    defp do_loop(memory, false, {old_paddle, old_ball}, input, _) do
      {snapshot, output, state} = Intcode.continue(memory, input)

      grouped = Enum.chunk_every(output, 3)
      paddle = Enum.find_value(grouped, &get_paddle/1)
      ball = Enum.find_value(grouped, &get_ball/1)
      score = Enum.find_value(grouped, &get_score/1)

      paddle_info = if paddle == nil, do: old_paddle, else: paddle
      ball_info = if ball == nil, do: old_ball, else: ball

      input =
        cond do
          paddle_info > ball_info -> -1
          ball_info > paddle_info -> 1
          true -> 0
        end

      do_loop(snapshot, state == :stop, {paddle_info, ball_info}, [input], score)
    end

    defp get_paddle([3, _, x]), do: x
    defp get_paddle(_), do: false

    defp get_ball([4, _, x]), do: x
    defp get_ball(_), do: false

    defp get_score([s, 0, -1]), do: s
    defp get_score(_), do: false
  end
end
