defmodule Aletopelta.Year2018.Day13 do
  @moduledoc """
  Day 13 of Year 2018
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 13
    """

    @type input() :: list(binary())
    @type position() :: {integer(), integer()}
    @type cart() :: {integer(), integer(), binary(), :left | :continue | :right}

    @spec parse_input(input()) :: {%{position() => binary()}, [cart()]}
    def parse_input(input) do
      input
      |> Enum.with_index()
      |> Enum.reduce({Map.new(), []}, &parse_line/2)
    end

    defp parse_line({line, y}, acc),
      do:
        line
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.reduce(acc, &parse_cell(&1, &2, y))

    defp parse_cell({single, x}, {grid, carts}, y) when single in ["-", "|", "+", "/", "\\"],
      do: {Map.put(grid, {x, y}, single), carts}

    defp parse_cell({single, x}, {grid, carts}, y) when single in ["v", "^", "<", ">"],
      do: {Map.put(grid, {x, y}, convert_cart(single)), [initial_cart(x, y, single) | carts]}

    defp parse_cell({" ", _}, acc, _), do: acc

    defp initial_cart(x, y, direction), do: {x, y, delta(direction), :left}

    defp convert_cart(cart) when cart in ["v", "^"], do: "|"
    defp convert_cart(cart) when cart in ["<", ">"], do: "-"

    defp delta("^"), do: {0, -1}
    defp delta("v"), do: {0, 1}
    defp delta("<"), do: {-1, 0}
    defp delta(">"), do: {1, 0}

    @spec start_loop({%{position() => binary()}, [cart()]}, boolean()) :: {[cart()], [cart()]}
    def start_loop({grid, carts}, stop?), do: do_loop(grid, carts, stop?)

    defp do_loop(grid, carts, stop?),
      do:
        carts
        |> Enum.sort_by(&sort_cart/1)
        |> move_carts(grid)
        |> next_state(grid, stop?)

    defp sort_cart({x, y, _, _}), do: {y, x}

    defp move_carts(carts, grid), do: move_carts(carts, grid, [], [])

    defp move_carts([], _, carts, collisions), do: {carts, collisions}

    defp move_carts([cart | carts], grid, final, collisions) do
      new_cart = move_cart(cart, grid)

      [carts, final]
      |> Enum.map_reduce(false, &remove_crash(&1, &2, new_cart))
      |> handle_crashed(grid, collisions, new_cart)
    end

    defp move_cart({_, _, direction, rotation} = cart, grid) do
      {x, y} = new_position = move_cart(cart)

      case Map.fetch(grid, new_position) do
        {:ok, "+"} -> change_direction(cart, new_position)
        {:ok, single} when single in ["/", "\\"] -> rotate_cart(cart, new_position, single)
        _ -> {x, y, direction, rotation}
      end
    end

    defp move_cart({x, y, {dx, dy}, _}), do: {x + dx, y + dy}

    defp change_direction({_, _, direction, :left = rotation}, {x, y}),
      do: {x, y, rotate(rotation, direction), :continue}

    defp change_direction({_, _, direction, :continue}, {x, y}), do: {x, y, direction, :right}

    defp change_direction({_, _, direction, :right = rotation}, {x, y}),
      do: {x, y, rotate(rotation, direction), :left}

    defp rotate_cart({_, _, {dx, dy} = direction, rotate}, {x, y}, sign)
         when (dx === 0 and sign === "\\") or (dy === 0 and sign === "/"),
         do: {x, y, rotate(:left, direction), rotate}

    defp rotate_cart({_, _, {dx, dy} = direction, rotate}, {x, y}, sign)
         when (dx === 0 and sign === "/") or (dy === 0 and sign === "\\"),
         do: {x, y, rotate(:right, direction), rotate}

    defp rotate(:left, {x, y}), do: {y, -x}
    defp rotate(:right, {x, y}), do: {-y, x}

    defp remove_crash([], crashed?, _), do: {[], crashed?}

    defp remove_crash([{x, y, _, _} | carts], crashed?, {x, y, _, _} = new_cart) do
      {new_carts, _} = remove_crash(carts, crashed?, new_cart)

      {new_carts, true}
    end

    defp remove_crash([cart | carts], crashed?, new_cart) do
      {new_carts, new_crashed?} = remove_crash(carts, crashed?, new_cart)

      {[cart | new_carts], new_crashed?}
    end

    defp handle_crashed({[carts, final], true}, grid, collisions, cart),
      do: move_carts(carts, grid, final, [cart | collisions])

    defp handle_crashed({[carts, final], false}, grid, collisions, cart),
      do: move_carts(carts, grid, [cart | final], collisions)

    defp next_state({[_], _} = infos, _, false), do: infos
    defp next_state({_, [_ | _]} = infos, _, true), do: infos
    defp next_state({carts, _}, grid, stop?), do: do_loop(grid, carts, stop?)

    @spec extract_position(cart()) :: list(integer())
    def extract_position({x, y, _, _}), do: [x, y]
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 13
    """
    @spec execute(Common.input(), []) :: binary()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.start_loop(true)
      |> elem(1)
      |> Enum.at(0)
      |> Common.extract_position()
      |> Enum.join(",")
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 13
    """
    @spec execute(Common.input(), []) :: binary()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.start_loop(false)
      |> elem(0)
      |> Enum.at(0)
      |> Common.extract_position()
      |> Enum.join(",")
    end
  end
end
