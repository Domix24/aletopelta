defmodule Aletopelta.Year2016.Day21 do
  @moduledoc """
  Day 21 of Year 2016
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 21
    """

    @type input() :: list(binary())
    @type output() :: binary()
    @type instruction() ::
            {:rotate, :left | :right, integer()}
            | {:swap, :letter, binary(), binary()}
            | {:swap, :position, integer(), integer()}
            | {:reverse, integer(), integer()}
            | {:move, integer(), integer()}
            | {:rotate, binary()}

    @spec parse_input(input()) :: list(instruction())
    def parse_input(input) do
      Enum.map(input, fn line ->
        line
        |> String.split()
        |> parse()
      end)
    end

    defp parse(["rotate", direction, amount, _]),
      do: {:rotate, Enum.at(~w"#{direction}"a, 0), String.to_integer(amount)}

    defp parse(["swap", "letter" = style, letter1, "with", style, letter2]),
      do: {:swap, :letter, letter1, letter2}

    defp parse(["swap", "position" = style, position1, "with", style, position2]),
      do: {:swap, :position, String.to_integer(position1), String.to_integer(position2)}

    defp parse(["reverse", "positions", position1, "through", position2]),
      do: {:reverse, String.to_integer(position1), String.to_integer(position2)}

    defp parse(["move", "position" = style, position1, "to", style, position2]),
      do: {:move, String.to_integer(position1), String.to_integer(position2)}

    defp parse(["rotate", "based", "on", "position", "of", "letter", letter]),
      do: {:rotate, letter}

    @spec execute(instruction(), %{password: binary(), undo: boolean()}) :: %{
            password: binary(),
            undo: boolean()
          }
    def execute(instruction, %{password: password, undo: undo}) do
      new_password = execute_instruction(instruction, password, undo)

      %{password: new_password, undo: undo}
    end

    defp execute_instruction({:rotate, :right, amount}, password, true),
      do: execute_instruction({:rotate, :left, amount}, password, false)

    defp execute_instruction({:rotate, :left, amount}, password, true),
      do: execute_instruction({:rotate, :right, amount}, password, false)

    defp execute_instruction({:rotate, :right, amount}, password, undo) do
      password_length = String.length(password)
      real_amount = rem(amount, password_length)

      execute_instruction({:rotate, :left, password_length - real_amount}, password, undo)
    end

    defp execute_instruction({:rotate, :left, amount}, password, _) do
      password_length = String.length(password)

      new_password =
        password
        |> String.graphemes()
        |> Enum.with_index(fn _, index ->
          :binary.at(password, rem(index + amount, password_length))
        end)

      "#{new_password}"
    end

    defp execute_instruction({:swap, :letter, letter1, letter2}, password, undo) do
      graphemes = String.graphemes(password)

      index1 = Enum.find_index(graphemes, fn letter -> letter === letter1 end)
      index2 = Enum.find_index(graphemes, fn letter -> letter === letter2 end)

      execute_instruction({:swap, :position, index1, index2}, password, undo)
    end

    defp execute_instruction({:swap, :position, position1, position2}, password, _) do
      graphemes = String.graphemes(password)

      new_password =
        Enum.with_index(graphemes, fn
          _, ^position1 -> :binary.at(password, position2)
          _, ^position2 -> :binary.at(password, position1)
          <<letter>>, _ -> letter
        end)

      "#{new_password}"
    end

    defp execute_instruction({:reverse, position1, position2}, password, _) do
      reverse =
        for position <- position1..position2//1, into: Map.new() do
          {position, position2 - position + position1}
        end

      new_password =
        password
        |> String.graphemes()
        |> Enum.with_index(fn
          _, position when is_map_key(reverse, position) ->
            :binary.at(password, Map.fetch!(reverse, position))

          <<letter>>, _ ->
            letter
        end)

      "#{new_password}"
    end

    defp execute_instruction({:move, position2, position1}, password, true),
      do: execute_instruction({:move, position1, position2}, password, false)

    defp execute_instruction({:move, position1, position2}, password, _)
         when position1 < position2 do
      new_password =
        password
        |> String.graphemes()
        |> Enum.with_index(fn
          _, ^position1 -> []
          <<letter>>, ^position2 -> [letter, :binary.at(password, position1)]
          <<letter>>, _ -> [letter]
        end)
        |> Enum.flat_map(& &1)

      "#{new_password}"
    end

    defp execute_instruction({:move, position1, position2}, password, _)
         when position1 > position2 do
      new_password =
        password
        |> String.graphemes()
        |> Enum.with_index(fn
          _, ^position1 -> []
          <<letter>>, ^position2 -> [:binary.at(password, position1), letter]
          <<letter>>, _ -> [letter]
        end)
        |> Enum.flat_map(& &1)

      "#{new_password}"
    end

    defp execute_instruction({:rotate, letter}, password, undo) do
      graphemes = String.graphemes(password)

      index =
        graphemes
        |> Enum.find_index(fn sub_letter -> sub_letter === letter end)
        |> adjust_index(undo)

      rotation = if index > 3, do: 2 + index, else: 1 + index

      if undo do
        execute_instruction({:rotate, :left, rotation}, password, false)
      else
        execute_instruction({:rotate, :right, rotation}, password, false)
      end
    end

    defp adjust_index(index, false), do: index
    defp adjust_index(index, _) when index < 1, do: index
    defp adjust_index(index, _) when rem(index, 2) < 1, do: div(index, 2) + 3
    defp adjust_index(index, _), do: div(index, 2)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 21
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Enum.reduce(%{password: "abcdefgh", undo: false}, &Common.execute/2)
      |> Map.fetch!(:password)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 21
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Enum.reverse()
      |> Enum.reduce(%{password: "fbgdceah", undo: true}, &Common.execute/2)
      |> Map.fetch!(:password)
    end
  end
end
