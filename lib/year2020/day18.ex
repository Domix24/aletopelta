defmodule Aletopelta.Year2020.Day18 do
  @moduledoc """
  Day 18 of Year 2020
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 18
    """

    @type input() :: list(binary())

    @spec parse_input(input()) :: list(list(binary() | integer()))
    def parse_input(input) do
      Enum.map(input, fn line ->
        ~r/[0-9]+|\+|\*|\(|\)/
        |> Regex.scan(line)
        |> Enum.map(fn
          [sign] when sign in ["+", "*", "(", ")"] -> sign
          [number] -> String.to_integer(number)
        end)
      end)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 18
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Enum.sum_by(fn line ->
        line
        |> parse_expression()
        |> elem(0)
      end)
    end

    defp parse_expression(tokens) do
      {left, left_tokens} = parse_value(tokens)
      continue_parse(left, left_tokens)
    end

    defp continue_parse(left, [op | tokens]) when op in ["+", "*"] do
      {right, right_tokens} = parse_value(tokens)

      result =
        case op do
          "+" -> left + right
          "*" -> left * right
        end

      continue_parse(result, right_tokens)
    end

    defp continue_parse(left, tokens), do: {left, tokens}

    defp parse_value(["(" | tokens]) do
      {value, [")" | rest]} = parse_expression(tokens)
      {value, rest}
    end

    defp parse_value([token | tokens]) do
      {token, tokens}
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 18
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Enum.sum_by(fn line ->
        line
        |> parse_multiply()
        |> elem(0)
      end)
    end

    defp parse_multiply(tokens) do
      {left, left_tokens} = parse_add(tokens)
      continue_parse(left, left_tokens, :multiply)
    end

    defp parse_add(tokens) do
      {left, left_tokens} = parse_value(tokens)
      continue_parse(left, left_tokens, :add)
    end

    defp continue_parse(left, ["*" | tokens], :multiply) do
      {right, right_tokens} = parse_add(tokens)
      result = left * right
      continue_parse(result, right_tokens, :multiply)
    end

    defp continue_parse(left, ["+" | tokens], :add) do
      {right, right_tokens} = parse_value(tokens)
      result = left + right
      continue_parse(result, right_tokens, :add)
    end

    defp continue_parse(left, tokens, _), do: {left, tokens}

    defp parse_value(["(" | tokens]) do
      {value, [")" | rest]} = parse_multiply(tokens)
      {value, rest}
    end

    defp parse_value([token | tokens]) do
      {token, tokens}
    end
  end
end
