defmodule Aletopelta.Day20241223 do
  defmodule Common do
    def parse_input(input) do
      Enum.reject(input, & &1 == "")
      |> Enum.map(& String.split(&1, "-"))
    end
  end

  defmodule Part1 do
    def execute(input \\ nil) do
      Common.parse_input(input)
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
  end

  defmodule Part2 do
    def execute(input \\ nil) do
      Common.parse_input(input)
      |> prepare_graph
      |> traverse_graph
      |> find_largest
    end

    defp prepare_graph(input) do
      prepare_graph(input, %{})
    end
    defp prepare_graph([], graph), do: graph
    defp prepare_graph([[a, b] | rest], graph) do
      graph = graph
      |> Map.update(a, MapSet.new([b]), &MapSet.put(&1, b))
      |> Map.update(b, MapSet.new([a]), &MapSet.put(&1, a))

      prepare_graph(rest, graph)
    end

    defp traverse_graph(graph) do
      traverse_graph(graph, [], Map.keys(graph), [], [])
    end
    defp traverse_graph(_, r, [], [], cliques), do: [Enum.sort(r) | cliques] |> Enum.uniq
    defp traverse_graph(graph, r, p, x, cliques) do
      if Enum.empty?(p) and Enum.empty?(x) do
        [Enum.sort(r) | cliques] |> Enum.uniq
      else
        u = Enum.max_by(p ++ x, fn v -> MapSet.size(Map.get(graph, v)) end)

        Enum.reduce(p -- MapSet.to_list(Map.get(graph, u)), cliques, fn v, acc ->
          new_r = r ++ [v]
          new_p = Enum.filter(p, fn u -> MapSet.member?(Map.get(graph, v), u) end)
          new_x = Enum.filter(x, fn u -> MapSet.member?(Map.get(graph, v), u) end)
          new_cliques = traverse_graph(graph, new_r, new_p, new_x, acc)
          Enum.concat(acc, new_cliques)
          |> Enum.uniq
        end)
      end
    end

    defp find_largest(cliques) do
      max_size = Enum.max_by(cliques, &length/1) |> length()
      Enum.filter(cliques, fn clique -> length(clique) == max_size end)
      |> Enum.at(0)
      |> Enum.join(",")
    end
  end
end
