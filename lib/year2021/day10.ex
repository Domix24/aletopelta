defmodule Aletopelta.Year2021.Day10 do
  @moduledoc """
  Day 10 of Year 2021
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 10
    """
    @spec parse_input([binary()]) :: [binary()]
    def parse_input(input) do
      input
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 10
    """
    @spec execute([binary()], []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Enum.flat_map(&corrupted/1)
      |> Enum.sum_by(&points/1)
    end

    defp points(")"), do: 3
    defp points("]"), do: 57
    defp points("}"), do: 1197
    defp points(">"), do: 25_137

    defp corrupted(line) do
      {state, corruption} = get_corrupted(line, <<0>>)

      if state do
        [corruption]
      else
        []
      end
    end

    defp get_corrupted(<<sign, rest::binary>>, other)
         when <<sign>> in ["<", "(", "[", "{"] and other in [<<0>>, "<", "(", "[", "{"] do
      case get_corrupted(rest, <<sign>>) do
        {false, new_rest} -> get_corrupted(new_rest, other)
        {true, _} = result -> result
      end
    end

    defp get_corrupted(<<sign, rest::binary>>, other)
         when <<sign>> === ">" and other === "<"
         when <<sign>> === ")" and other === "("
         when <<sign>> === "]" and other === "["
         when <<sign>> === "}" and other === "{",
         do: {false, rest}

    defp get_corrupted("", _), do: {false, ""}
    defp get_corrupted(<<sign, _::binary>>, _), do: {true, <<sign>>}
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 10
    """
    @spec execute([binary()], []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Enum.flat_map(&incomplete/1)
      |> Enum.sort()
      |> middle()
    end

    defp points(")"), do: 1
    defp points("]"), do: 2
    defp points("}"), do: 3
    defp points(">"), do: 4

    defp incomplete(line) do
      {state, incompletion} = get_incomplete(line, <<0>>)

      if state === :incomplete do
        score =
          incompletion
          |> convert()
          |> Enum.reverse()
          |> score()

        [score]
      else
        []
      end
    end

    defp get_incomplete(<<sign, rest::binary>>, other)
         when <<sign>> in ["<", "(", "[", "{"] and other in [<<0>>, "<", "(", "[", "{"] do
      case get_incomplete(rest, <<sign>>) do
        {:closed, new_rest} -> get_incomplete(new_rest, other)
        {:incomplete, new_signs} -> {:incomplete, [other | new_signs]}
        {:corrupted, nil} -> {:corrupted, nil}
      end
    end

    defp get_incomplete(<<sign, rest::binary>>, other)
         when <<sign>> === ">" and other === "<"
         when <<sign>> === ")" and other === "("
         when <<sign>> === "]" and other === "["
         when <<sign>> === "}" and other === "{",
         do: {:closed, rest}

    defp get_incomplete("", <<0>>), do: {:perfect, ""}
    defp get_incomplete("", sign), do: {:incomplete, [sign]}
    defp get_incomplete(_, _), do: {:corrupted, nil}

    defp convert([]), do: []
    defp convert([<<0>> | others]), do: convert(others)
    defp convert(["(" | others]), do: [points(")") | convert(others)]
    defp convert(["[" | others]), do: [points("]") | convert(others)]
    defp convert(["{" | others]), do: [points("}") | convert(others)]
    defp convert(["<" | others]), do: [points(">") | convert(others)]

    defp score(points), do: score(points, 0)
    defp score([], total), do: total
    defp score([point | others], total), do: score(others, total * 5 + point)

    defp middle(points) do
      points
      |> Enum.count()
      |> div(2)
      |> middle(points, 0)
    end

    defp middle(middle, [_ | others], index) when index < middle,
      do: middle(middle, others, index + 1)

    defp middle(_, [current | _], _), do: current
  end
end
