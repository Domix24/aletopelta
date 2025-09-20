defmodule Aletopelta.Year2018.Day08 do
  @moduledoc """
  Day 8 of Year 2018
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 8
    """

    @type input() :: list(binary())
    @type output() :: list(integer())
    @type inode() :: %{nodes: %{integer() => inode()}, metadatas: list(integer())}

    @spec parse_input(input()) :: output()
    def parse_input(input) do
      Enum.flat_map(input, fn line ->
        ~r"\d+"
        |> Regex.scan(line)
        |> Enum.map(fn [number] ->
          String.to_integer(number)
        end)
      end)
    end

    @spec build_graph(output()) :: {inode(), output()}
    def build_graph([nb_nodes, nb_metas | rest]) do
      {nodes, rest_one} = take_node(rest, nb_nodes)
      {metadatas, rest_two} = take_metadata(rest_one, nb_metas)

      map =
        nodes
        |> Enum.with_index(fn node, index ->
          {index + 1, node}
        end)
        |> Map.new()

      {%{nodes: map, metadatas: metadatas}, rest_two}
    end

    defp take_node(list, 0), do: {[], list}

    defp take_node(list, n) do
      {node, first_rest} = build_graph(list)

      {nodes, next_rest} = take_node(first_rest, n - 1)

      {[node | nodes], next_rest}
    end

    defp take_metadata(list, 0), do: {[], list}

    defp take_metadata([metadata | rest], n) do
      {metadatas, next_rest} = take_metadata(rest, n - 1)

      {[metadata | metadatas], next_rest}
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 8
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      Common.parse_input(input)

      input
      |> Common.parse_input()
      |> Common.build_graph()
      |> elem(0)
      |> sum_metadata()
    end

    defp sum_metadata(node) do
      sum = Enum.sum(node.metadatas)

      Enum.reduce(node.nodes, sum, fn {_, node}, acc ->
        acc + sum_metadata(node)
      end)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 8
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.build_graph()
      |> elem(0)
      |> mixed_sum()
    end

    defp mixed_sum(%{nodes: nodes, metadatas: metadatas}) when map_size(nodes) === 0,
      do: Enum.sum(metadatas)

    defp mixed_sum(%{nodes: nodes, metadatas: metadatas}) do
      metadatas
      |> Enum.frequencies()
      |> Enum.sum_by(fn {index, count} ->
        nodes
        |> Map.get(index, %{nodes: %{}, metadatas: []})
        |> mixed_sum()
        |> Kernel.*(count)
      end)
    end
  end
end
