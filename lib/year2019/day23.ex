defmodule Aletopelta.Year2019.Day23 do
  @moduledoc """
  Day 23 of Year 2019
  """
  alias Aletopelta.Year2019.Intcode

  defmodule Common do
    @moduledoc """
    Common part for Day 23
    """

    @type input() :: list(binary())
    @type state() :: %{
            target: nil | integer(),
            index: integer(),
            computers: %{integer() => computer()},
            nat: nil | {integer(), integer()},
            deliver: nil | integer()
          }
    @type computer() :: %{
            output: [integer()],
            state: atom(),
            program: Intcode.intcode(),
            index: integer(),
            base: integer(),
            input: [integer()]
          }

    @spec parse_input(input()) :: Intcode.intcode()
    def parse_input(input) do
      Intcode.parse(input)
    end

    @spec prepare_loop(Intcode.intcode(), integer()) :: state()
    def prepare_loop(intcode, max \\ 49) do
      computers =
        Map.new(0..max, fn address ->
          {address, start_computer(intcode, address)}
        end)

      Map.new()
      |> Map.put(:target, nil)
      |> Map.put(:index, 0)
      |> Map.put(:computers, computers)
      |> Map.put(:nat, nil)
      |> Map.put(:deliver, nil)
    end

    @spec next_step(state(), integer()) :: state()
    def next_step(state, target \\ 255) do
      if Enum.all?(state.computers, fn {_, %{input: input}} -> input === [] end) and
           !is_nil(state.nat) do
        restart(state)
      else
        run(state, target)
      end
    end

    defp restart(state) do
      {_, y} = state.nat

      new_computer =
        state.computers
        |> Map.fetch!(0)
        |> Map.put(:input, [state.nat])

      new_computers = Map.put(state.computers, 0, new_computer)

      %{computers: new_computers, index: 0, target: nil, nat: nil, deliver: y}
    end

    defp run(state, target) do
      computer =
        state.computers
        |> Map.fetch!(state.index)
        |> run_computer()

      new_computers = Map.put(state.computers, state.index, computer)

      {with_target, without_target} = split_output(computer, target)

      computers =
        Enum.reduce(without_target, new_computers, fn {destination, packets}, actual_computers ->
          Map.update!(actual_computers, destination, fn old_computer ->
            Map.update!(old_computer, :input, &(&1 ++ packets))
          end)
        end)

      index = rem(state.index + 1, 50)
      y = extract_y(target, with_target)
      nat = get_last(target, with_target)

      %{computers: computers, index: index, target: y, nat: nat, deliver: nil}
    end

    defp split_output(%{output: output}, target),
      do:
        output
        |> Enum.reverse()
        |> Enum.chunk_every(3)
        |> Enum.group_by(fn [destination, _, _] -> destination end, fn [_, x, y] -> {x, y} end)
        |> Enum.split_with(fn {destination, _} -> destination === target end)

    defp extract_y(_, []), do: nil
    defp extract_y(target, [{target, [{_, y} | _]}]), do: y

    defp get_last(_, []), do: nil
    defp get_last(target, [{target, [{_, _} = packet]}]), do: packet

    defp start_computer(intcode, address) do
      run_computer(%{program: intcode, index: 0, base: 0}, [address], [])
    end

    defp run_computer(%{program: program, index: index, base: base}, input, messages) do
      %{program: program, index: index, base: base}
      |> Intcode.continue(input)
      |> format_computer(messages)
    end

    defp format_computer({%{program: program, index: index, base: base}, output, state}, messages) do
      %{output: output, state: state, program: program, index: index, base: base, input: messages}
    end

    defp run_computer(%{input: []} = computer), do: run_computer(computer, [-1], [])

    defp run_computer(%{input: [{x, y} | rest]} = computer),
      do: run_computer(computer, [x, y], rest)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 23
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.prepare_loop()
      |> Stream.iterate(&Common.next_step/1)
      |> Enum.find_value(& &1.target)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 23
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.prepare_loop()
      |> Stream.iterate(&Common.next_step/1)
      |> Stream.map(& &1.deliver)
      |> Stream.reject(&is_nil/1)
      |> Stream.transform(Map.new(), fn
        y, acc when is_map_key(acc, y) -> {[y], acc}
        y, acc -> {[], Map.put(acc, y, 0)}
      end)
      |> Enum.take(1)
      |> Enum.at(0)
    end
  end
end
