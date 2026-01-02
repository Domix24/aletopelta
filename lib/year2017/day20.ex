defmodule Aletopelta.Year2017.Day20 do
  @moduledoc """
  Day 20 of Year 2017
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 20
    """

    @type input() :: list(binary())
    @type output() :: integer()
    @type particle() :: {integer(), {list(integer()), list(integer()), list(integer())}}

    @spec parse_input(input()) :: list(particle())
    def parse_input(input) do
      Enum.with_index(input, fn line, index ->
        [px, py, pz, vx, vy, vz, ax, ay, az] =
          ~r"-?\d+"
          |> Regex.scan(line)
          |> Enum.map(fn [number] -> String.to_integer(number) end)

        {index, {[px, py, pz], [vx, vy, vz], [ax, ay, az]}}
      end)
    end

    @spec move_particles(list(particle())) :: list(particle())
    def move_particles(particles), do: Enum.map(particles, &move_particle/1)

    defp move_particle({index, {old_position, old_velocity, acceleration}}) do
      [{px, vx}, {py, vy}, {pz, vz}] =
        Enum.zip_with([old_position, old_velocity, acceleration], fn [p, v, a] ->
          {p + v + a, v + a}
        end)

      {index, {[px, py, pz], [vx, vy, vz], acceleration}}
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 20
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> do_loop()
      |> Enum.find(&(elem(&1, 1) === 250))
      |> elem(0)
    end

    defp do_loop(particles) do
      particles
      |> Stream.iterate(&Common.move_particles/1)
      |> Stream.transform(nil, fn particles, acc ->
        particles
        |> Enum.min_by(fn {_, {[x, y, z], _, _}} ->
          abs(x) + abs(y) + abs(z)
        end)
        |> elem(0)
        |> process_closest(acc)
        |> copy()
      end)
    end

    defp process_closest(index, {index, count}), do: {index, count + 1}
    defp process_closest(index, _), do: {index, 1}

    defp copy(number), do: {[number], number}
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 20
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> do_loop()
      |> Enum.find(&(elem(&1, 1) === 3))
      |> elem(2)
    end

    defp do_loop(particles),
      do:
        {[], particles}
        |> Stream.iterate(&iterate/1)
        |> Stream.transform(nil, &transform/2)

    defp iterate({_, not_collided}),
      do:
        not_collided
        |> Common.move_particles()
        |> remove_collision()

    defp transform({[], _}, nil), do: {[], nil}

    defp transform({[], _}, {index, count, free_length}) do
      acc = {index, count + 1, free_length}
      {[acc], acc}
    end

    defp transform({[_ | _], free}, old_acc) do
      acc = {add(old_acc), 1, length(free)}
      {[acc], acc}
    end

    defp add({index, _, _}), do: index + 1
    defp add(nil), do: 1

    defp remove_collision(particles),
      do:
        particles
        |> remove_collision([])
        |> split(particles)

    defp split(found_collisions, particles),
      do: Enum.split_with(particles, &(elem(&1, 0) in found_collisions))

    defp remove_collision([], collided), do: collided

    defp remove_collision([{index, {[px, py, pz], _, _}} | rest], collided) do
      if index in collided do
        remove_collision(rest, collided)
      else
        rest
        |> Enum.filter(fn {_, {[opx, opy, opz], _, _}} ->
          opx === px and opy === py and opz === pz
        end)
        |> Enum.map(&elem(&1, 0))
        |> process_collision(rest, collided, index)
      end
    end

    defp process_collision([], rest, collided, _), do: remove_collision(rest, collided)

    defp process_collision(other_collided, rest, collided, index),
      do: remove_collision(rest, Enum.concat(collided, [index | other_collided]))
  end
end
