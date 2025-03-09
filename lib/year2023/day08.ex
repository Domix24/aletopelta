defmodule Aletopelta.Year2023.Day08 do
  @moduledoc """
  Day 8 of Year 2023
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 8
    """
    def parse_input(input) do
      directions = Enum.take(input, 1) |> Enum.at(0) |> String.graphemes()

      nodes = Enum.drop(input, 2) |> Map.new(&parse_node/1)
      {directions, nodes}
    end

    defp parse_node(line) do
      [[source], [left], [right]] = Regex.scan(~r/\w+/, line)
      {source, {left, right}}
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 8
    """
    def execute(input) do
      Common.parse_input(input)
      |> start_loop
    end

    defp start_loop({directions, nodes}) do
      start_loop({directions, nodes}, "AAA", 0)
    end

    defp start_loop({directions, nodes}, source, index) do
      navigate_graph({directions, nodes}, source, index)
      |> case do
        {source, index} -> start_loop({directions, nodes}, source, index)
        index -> index
      end
    end

    defp navigate_graph({[], _}, source, index), do: {source, index}

    defp navigate_graph({[first | others], nodes}, source, index) do
      Map.fetch!(nodes, source)
      |> elem(if first == "L", do: 0, else: 1)
      |> case do
        "ZZZ" -> index + 1
        source -> navigate_graph({others, nodes}, source, index + 1)
      end
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 8
    """
    def execute(input) do
      Common.parse_input(input)
      |> start_loop
      |> find_multiple
    end

    defp start_loop({directions, nodes}) do
      Enum.filter(nodes, fn
        {<<_::16, ?A>>, _} -> true
        _ -> false
      end)
      |> Enum.map(fn {start, _} -> start_loop({directions, nodes}, start, 0) end)
    end

    defp start_loop({directions, nodes}, source, index) do
      navigate_graph({directions, nodes}, source, index)
      |> case do
        {source, index} -> start_loop({directions, nodes}, source, index)
        index -> index
      end
    end

    defp navigate_graph({[], _}, source, index), do: {source, index}

    defp navigate_graph({[first | others], nodes}, source, index) do
      Map.fetch!(nodes, source)
      |> elem(if first == "L", do: 0, else: 1)
      |> case do
        <<_::16, ?Z>> -> index + 1
        source -> navigate_graph({others, nodes}, source, index + 1)
      end
    end

    defp find_divisor(number1, number2) when number1 > number2 do
      case rem(number1, number2) do
        0 -> number2
        remainder -> find_divisor(number2, remainder)
      end
    end

    defp find_divisor(number1, number2) do
      find_divisor(number2, number1)
    end

    defp find_multiple([number1, number2]) do
      div(number1 * number2, find_divisor(number1, number2))
    end

    defp find_multiple([number1, number2 | others]) do
      find_multiple([number1, find_multiple([number2 | others])])
    end
  end
end
