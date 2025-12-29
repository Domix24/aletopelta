defmodule Aletopelta.Year2017.Day07 do
  @moduledoc """
  Day 7 of Year 2017
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 7
    """

    @type input() :: list(binary())
    @type output() :: none()
    @type upgraph() :: %{binary() => {integer(), list(binary())}}
    @type downgraph() :: %{binary() => binary()}

    @spec parse_input(input()) :: list({binary(), integer(), list(binary())})
    def parse_input(input) do
      Enum.map(input, fn line ->
        [node, weight, old_rest] =
          Regex.run(~r"(\w+) \((\d+)\)(.*)$", line, capture: :all_but_first)

        rest =
          case old_rest do
            "" ->
              []

            _ ->
              ~r"\w+"
              |> Regex.scan(old_rest)
              |> Enum.flat_map(& &1)
          end

        {node, String.to_integer(weight), rest}
      end)
    end

    @spec build_graph(list({binary(), integer(), list(binary())})) :: {upgraph(), downgraph()}
    def build_graph(nodes), do: Enum.reduce(nodes, {Map.new(), Map.new()}, &build_graph/2)

    defp build_graph({node, weight, childs}, {old_upgraph, old_downgraph}) do
      upgraph = Map.put(old_upgraph, node, {weight, childs})

      downgraph =
        Enum.reduce(childs, old_downgraph, fn child, acc ->
          Map.put(acc, child, node)
        end)

      {upgraph, downgraph}
    end

    @spec find_root({upgraph(), downgraph()}) :: binary()
    def find_root({_, downgraph}) do
      {_, node} = Enum.at(downgraph, 0)
      find_root(node, downgraph)
    end

    defp find_root(node, downgraph) do
      case Map.get(downgraph, node) do
        nil -> node
        parent -> find_root(parent, downgraph)
      end
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 7
    """
    @spec execute(Common.input(), []) :: binary()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.build_graph()
      |> Common.find_root()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 7
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.build_graph()
      |> do_loop()
    end

    defp do_loop({upgraph, _} = graphs) do
      root = Common.find_root(graphs)

      upgraph
      |> do_loop(root)
      |> elem(1)
    end

    defp do_loop(graph, node) do
      {weight, list} = Map.fetch!(graph, node)
      weights = Enum.map(list, &do_loop(graph, &1))

      found =
        Enum.find(weights, fn
          {:found, _} -> true
          _ -> false
        end)

      case found do
        {:found, _} = return ->
          return

        nil ->
          weights
          |> Enum.uniq_by(&Enum.sum/1)
          |> Enum.count()
          |> handle_count(weight, weights)
      end
    end

    defp handle_count(0, weight, _), do: [weight]
    defp handle_count(1, weight, weights), do: [weight, Enum.sum_by(weights, &Enum.sum/1)]

    defp handle_count(_, _, weights) do
      {{bad, 1}, {good, _}} =
        weights
        |> Enum.frequencies_by(&Enum.sum/1)
        |> Enum.min_max_by(&elem(&1, 1))

      Enum.reduce_while(weights, 0, fn [_, child_weight] = list, _ ->
        if Enum.sum(list) === bad do
          {:halt, {:found, good - child_weight}}
        else
          {:cont, nil}
        end
      end)
    end
  end
end
