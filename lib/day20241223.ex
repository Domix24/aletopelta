defmodule Aletopelta.Day20241223 do
  defmodule Common do
  end

  defmodule Part1 do
    def execute(input \\ nil) do
      parse_input(input)
      |> do_sets([])
      |> Enum.count
    end

    defp do_sets([], map), do: map
    defp do_sets([["t" <> _ = a, b] | others], map), do: do_sets([[a, b] | others], map, "")
    defp do_sets([[a, "t" <> _ = b] | others], map), do: do_sets([[a, b] | others], map, "")
    defp do_sets([[a, b] | others], map), do: do_sets([[a, b] | others], map, "t")
    defp do_sets([[a, b] | others], map, p) do
      map = Enum.map(others, fn
        [^a, ^p <> _ = x] -> Enum.find_value(others, &get_third(&1, a, x, b, 1))
        [^p <> _ = x, ^a] -> Enum.find_value(others, &get_third(&1, a, x, b, 1))
        [^b, ^p <> _ = x] -> Enum.find_value(others, &get_third(&1, a, x, b, 2))
        [^p <> _ = x, ^b] -> Enum.find_value(others, &get_third(&1, a, x, b, 2))
        _ -> nil
      end)
      |> Enum.reject(& &1 == nil)
      |> Enum.uniq
      |> Enum.reduce(map, fn seq, acc ->
        [Enum.join(seq, ",") | acc]
      end)

      do_sets(others, map)
    end

    defp get_third([b, x], a, x, b, 1), do: [a, x, b]
    defp get_third([x, b], a, x, b, 1), do: [a, x, b]
    defp get_third([a, x], a, x, b, 2), do: [a, x, b]
    defp get_third([x, a], a, x, b, 2), do: [a, x, b]
    defp get_third(_, _, _, _, _), do: nil

    defp parse_input(input) do
      Enum.reject(input, & &1 == "")
      |> Enum.map(& String.split(&1, "-"))
    end
  end

  defmodule Part2 do
    def execute(_input \\ nil), do: 2
  end
end
