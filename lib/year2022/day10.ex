defmodule Aletopelta.Year2022.Day10 do
  @moduledoc """
  Day 10 of Year 2022
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 10
    """
    @spec parse_input(any()) :: list()
    def parse_input(input) do
      Enum.map(input, &String.split/1)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 10
    """
    @spec execute(any()) :: number()
    def execute(input) do
      input
      |> Common.parse_input()
      |> Enum.reduce({[{0, 1}], 1, 0}, &follow_instructions/2)
      |> elem(0)
      |> Enum.reverse()
      |> Stream.drop(19)
      |> Stream.take_every(40)
      |> Enum.sum_by(&get_strength/1)
    end

    defp get_strength({cycle, x}), do: (cycle + 1) * x

    defp follow_instructions(["noop"], accumulator) do
      follow_instruction("noop", accumulator)
    end

    defp follow_instructions(["addx", number_string], accumulator) do
      new_accumulator = follow_instruction("addx", accumulator)
      follow_instruction(String.to_integer(number_string), new_accumulator)
    end

    defp follow_instruction(instruction, {history, x, index})
         when instruction == "noop"
         when instruction == "addx" do
      new_index = index + 1

      new_history = [{new_index, x} | history]
      {new_history, x, new_index}
    end

    defp follow_instruction(number, {history, x, index}) when is_integer(number) do
      new_index = index + 1
      new_x = x + number

      new_history = [{new_index, new_x} | history]
      {new_history, new_x, new_index}
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 10
    """
    @spec execute(any()) :: list()
    def execute(input) do
      input
      |> Common.parse_input()
      |> Enum.reduce({[], 0..2//1, 0, 1}, &follow_instructions/2)
      |> elem(0)
      |> Enum.reverse()
      |> Enum.chunk_every(40)
      |> Enum.map(&Enum.join/1)
    end

    defp follow_instructions(["noop"], accumulator) do
      follow_instruction("noop", accumulator)
    end

    defp follow_instructions(["addx", number], accumulator) do
      new_accumulator = follow_instruction("addx", accumulator)
      follow_instruction(String.to_integer(number), new_accumulator)
    end

    defp follow_instruction(instruction, {display, sprite, position, x})
         when instruction == "noop"
         when instruction == "addx" do
      new_display = [get_sign(sprite, position) | display]
      new_position = rem(position + 1, 40)

      {new_display, sprite, new_position, x}
    end

    defp follow_instruction(number, {display, sprite, position, x}) when is_integer(number) do
      new_display = [get_sign(sprite, position) | display]
      new_position = rem(position + 1, 40)
      new_x = x + number
      new_sprite = (new_x - 1)..(new_x + 1)//1

      {new_display, new_sprite, new_position, new_x}
    end

    defp get_sign(sprite, position) do
      if position in sprite do
        "#"
      else
        "."
      end
    end
  end
end
