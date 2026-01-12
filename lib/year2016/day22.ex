defmodule Aletopelta.Year2016.Day22 do
  @moduledoc """
  Day 22 of Year 2016
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 22
    """

    @type input() :: list(binary())
    @type output() :: integer()
    @type filesystem() :: %{
            position: {integer(), integer()},
            size: integer(),
            used: integer(),
            available: integer()
          }

    @spec parse_input(input()) :: list(filesystem())
    def parse_input(input) do
      input
      |> Enum.drop(2)
      |> Enum.map(fn line ->
        [x, y, size, used, avail, _] =
          ~r"\d+"
          |> Regex.scan(line)
          |> Enum.flat_map(& &1)
          |> Enum.map(&String.to_integer/1)

        %{position: {x, y}, size: size, used: used, available: avail}
      end)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 22
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> find_pairs()
      |> Enum.count()
    end

    defp find_pairs(nodes), do: find_pairs(nodes, nodes)

    defp find_pairs([node | rest], complete),
      do: find_pairs(node, complete, nil) ++ find_pairs(rest, complete)

    defp find_pairs([], _), do: []

    defp find_pairs(node, [compare | rest], nil) when node.position === compare.position,
      do: find_pairs(node, rest, nil)

    defp find_pairs(node, [compare | rest], nil)
         when node.used > 0 and node.used <= compare.available,
         do: [{node, compare} | find_pairs(node, rest, nil)]

    defp find_pairs(node, [_ | rest], nil), do: find_pairs(node, rest, nil)
    defp find_pairs(_, [], nil), do: []
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 22
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> do_loop()
    end

    defp do_loop(map) do
      %{position: {width, _}} = Enum.max_by(map, &elem(&1.position, 0))
      {wall, usable} = Enum.split_with(map, &(&1.size > 100))
      %{position: empty} = Enum.find(usable, &(&1.used < 1))

      wall
      |> extract()
      |> process(empty, width)
    end

    defp process({first..width//1 = x_range, y}, {empty_x, empty_y}, width)
         when y < empty_y and empty_x in first..width//1 do
      y_towall = empty_y - y - 1
      x_outside = empty_x - first + 1
      y_tozero = empty_y
      x_togoal = Range.size(x_range)
      x_tozero = width - 1
      y_towall + x_outside + y_tozero + x_togoal + x_tozero * 5
    end

    defp extract(wall), do: Enum.reduce(wall, nil, &reduce/2)

    defp reduce(%{position: {x, y}}, nil), do: {x, y}

    defp reduce(%{position: {x, y}}, {acc_xfirst..acc_xlast//1, y}),
      do: {min(acc_xfirst, x)..max(acc_xlast, x), y}

    defp reduce(%{position: {x, y}}, {acc_x, y}), do: {min(acc_x, x)..max(acc_x, x), y}
  end
end
