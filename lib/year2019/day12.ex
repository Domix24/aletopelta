defmodule Aletopelta.Year2019.Day12 do
  @moduledoc """
  Day 12 of Year 2019
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 12
    """

    @type input() :: list(binary())
    @type position() :: integer()
    @type velocity() :: integer()
    @type coord() :: {position(), velocity()}
    @type moon() :: {list(coord()), integer()}
    @type moons() :: list(moon())
    @type axis() :: 0 | 1 | 2

    @spec parse_input(input()) :: moons()
    def parse_input(input) do
      input
      |> Enum.map(fn line ->
        ~r/(-?\d+)/
        |> Regex.scan(line, capture: :all_but_first)
        |> Enum.map(fn [string] -> String.to_integer(string) end)
        |> append_velocity()
      end)
      |> Enum.with_index()
    end

    defp append_velocity([x, y, z]), do: [{x, 0}, {y, 0}, {z, 0}]

    @spec apply_gravity(moons(), moons(), axis()) :: moons()
    def apply_gravity(moons1, moons2, axis) do
      Enum.reduce(moons1, moons2, fn moon, acc ->
        apply_gravity(moon, acc, axis, :map)
      end)
    end

    defp apply_gravity(moon, moons, axis, :map) do
      apply_gravity(moon, moons, axis, moons)
    end

    defp apply_gravity(moon, [], _, :map2), do: moon

    defp apply_gravity({_, index} = moon, [{_, index} | rest], axis, :map2 = atom) do
      apply_gravity(moon, rest, axis, atom)
    end

    defp apply_gravity(moon, [{moon2, _} | rest], axis, :map2 = atom) do
      moon
      |> apply_gravity(moon2, axis, :map3)
      |> apply_gravity(rest, axis, atom)
    end

    defp apply_gravity({moon, index}, moon2, axis, :map3),
      do: {apply_gravity(moon, moon2, axis, :map4), index}

    defp apply_gravity([{p1, v}, y, z], [{p2, _}, _, _], 0, :map4) do
      nv = v + apply_velocity(p1, p2, :priv)
      [{p1, nv}, y, z]
    end

    defp apply_gravity([x, {p1, v}, z], [_, {p2, _}, _], 1, :map4) do
      nv = v + apply_velocity(p1, p2, :priv)
      [x, {p1, nv}, z]
    end

    defp apply_gravity([x, y, {p1, v}], [_, _, {p2, _}], 2, :map4) do
      nv = v + apply_velocity(p1, p2, :priv)
      [x, y, {p1, nv}]
    end

    defp apply_gravity({_, index} = moon, [{_, index} | rest], axis, moons) do
      [apply_gravity(moon, moons, axis, :map2) | rest]
    end

    defp apply_gravity(current, [moon | moons], axis, full) do
      [moon | apply_gravity(current, moons, axis, full)]
    end

    @spec apply_velocity(moons(), axis()) :: moons()
    def apply_velocity([_ | _] = moons, axis) do
      Enum.map(moons, fn {positions, moon_index} ->
        positions
        |> Enum.with_index(fn
          {p, v}, ^axis -> {p + v, v}
          position, _ -> position
        end)
        |> then(fn positions ->
          {positions, moon_index}
        end)
      end)
    end

    defp apply_velocity(p1, p2, :priv) when p1 > p2, do: -1
    defp apply_velocity(p1, p2, :priv) when p1 < p2, do: 1
    defp apply_velocity(p1, p1, :priv), do: 0
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 12
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> do_loop(1000)
      |> Enum.reduce(0, &reduce/2)
    end

    defp do_loop(moons, count) do
      0..2
      |> Enum.map(fn axis -> do_loop(moons, axis, count) end)
      |> mix()
    end

    defp do_loop(moons, 0, 0), do: Enum.map(moons, fn {[v, _, _], _} -> v end)
    defp do_loop(moons, 1, 0), do: Enum.map(moons, fn {[_, v, _], _} -> v end)
    defp do_loop(moons, 2, 0), do: Enum.map(moons, fn {[_, _, v], _} -> v end)

    defp do_loop(moons, axis, count) do
      moons
      |> Common.apply_gravity(moons, axis)
      |> Common.apply_velocity(axis)
      |> do_loop(axis, count - 1)
    end

    defp mix([[], [], []]), do: []
    defp mix([[x | rx], [y | ry], [z | rz]]), do: [[x, y, z] | mix([rx, ry, rz])]

    defp reduce([{px, vx}, {py, vy}, {pz, vz}], acc),
      do: (abs(px) + abs(py) + abs(pz)) * (abs(vx) + abs(vy) + abs(vz)) + acc
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 12
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> do_loop()
      |> lcm()
    end

    defp do_loop(moons) do
      Enum.map(0..2, fn axis ->
        initial = Enum.map(moons, &get_axis(axis, &1))
        find_step(axis, initial, moons)
      end)
    end

    defp get_axis(0, {[v, _, _], i}), do: {v, i}
    defp get_axis(1, {[_, v, _], i}), do: {v, i}
    defp get_axis(2, {[_, _, v], i}), do: {v, i}

    defp find_step(axis, initial, moons) do
      {moons, 0}
      |> Stream.iterate(fn {acc_moons, acc_count} ->
        acc_moons
        |> Common.apply_gravity(acc_moons, axis)
        |> Common.apply_velocity(axis)
        |> then(fn r -> {r, acc_count + 1} end)
      end)
      |> Enum.find_value(fn
        {_, 0} ->
          false

        {moons, step} ->
          moon_axis = Enum.map(moons, &get_axis(axis, &1))

          if initial?(moon_axis, initial, true) do
            step
          end
      end)
    end

    defp initial?([], [], state), do: state

    defp initial?([moon_position | moon_positions], [moon_position | initial_positions], true),
      do: initial?(moon_positions, initial_positions, true)

    defp initial?([_ | _], [_ | _], _), do: false

    defp gcd(a, 0), do: abs(a)
    defp gcd(a, b), do: gcd(b, rem(a, b))

    defp lcm(a, b), do: div(abs(a * b), gcd(a, b))

    defp lcm([a, b]), do: lcm(a, b)
    defp lcm([a, b | c]), do: lcm([lcm(a, b) | c])
  end
end
