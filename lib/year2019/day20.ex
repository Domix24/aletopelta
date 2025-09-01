defmodule Aletopelta.Year2019.Day20 do
  @moduledoc """
  Day 20 of Year 2019
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 20
    """

    @type input() :: list(binary())
    @type coord() :: {integer(), integer()}
    @type free() :: :free
    @type portal() :: {:portal, %{name: binary(), destination: coord(), outer?: boolean()}}
    @type point() :: %{position: coord(), level: integer()}
    @type output() :: {%{{integer(), integer()} => free() | portal()}, point()}

    @spec parse_input(input()) :: output()
    def parse_input(input) do
      parsed =
        input
        |> Enum.with_index()
        |> Enum.flat_map(fn {line, y} ->
          line
          |> String.graphemes()
          |> Enum.with_index()
          |> Enum.reject(&(elem(&1, 0) in ["#", " "]))
          |> Enum.map(fn {chr, x} -> {{x, y}, chr} end)
        end)
        |> Map.new()

      portals = parse_portals(parsed)
      portals_map = Map.new(portals, &{{&1.name, !&1.outer?}, &1.position})

      portals_objects =
        Enum.map(
          portals,
          &{&1.position,
           {:portal,
            %{
              name: &1.name,
              outer?: &1.outer?,
              destination: get_destination(portals_map, parsed, &1)
            }}}
        )

      final =
        parsed
        |> Enum.filter(&(elem(&1, 1) === "."))
        |> Enum.map(&{elem(&1, 0), :free})
        |> Enum.concat(portals_objects)
        |> Map.new()

      start =
        portals_map
        |> Map.get({"AA", false})
        |> get_sides()
        |> Enum.find(&(Map.get(final, &1) === :free))

      {final, %{position: start, level: 0}}
    end

    defp get_destination(map, parsed, portal),
      do:
        map
        |> Map.get({portal.name, portal.outer?})
        |> then(fn
          nil ->
            nil

          position ->
            position
            |> get_sides()
            |> Enum.find(&(Map.get(parsed, &1) == "."))
        end)

    defp parse_portals(unparsed) do
      {{maxx, _}, _} = Enum.max_by(unparsed, fn {{v, _}, _} -> v end)
      {{_, maxy}, _} = Enum.max_by(unparsed, fn {{_, v}, _} -> v end)

      unparsed
      |> Enum.reject(&(elem(&1, 1) == "."))
      |> Enum.map(fn {first_position, first_letter} ->
        [{second_position, second_letter}] =
          first_position
          |> get_sides()
          |> Enum.map(fn position ->
            sign = Map.get(unparsed, position, ".")
            {position, sign}
          end)
          |> Enum.reject(&(elem(&1, 1) === "."))

        {x, y} =
          entry_position =
          [first_position, second_position]
          |> Enum.map(fn position ->
            result =
              position
              |> get_sides()
              |> Enum.find(&(Map.get(unparsed, &1) === "."))

            result && position
          end)
          |> Enum.find(& &1)

        full_name =
          if first_position < second_position,
            do: first_letter <> second_letter,
            else: second_letter <> first_letter

        %{
          position: entry_position,
          name: full_name,
          outer?: x in [1, maxx - 1] or y in [1, maxy - 1]
        }
      end)
      |> Enum.uniq()
    end

    @spec get_sides({integer(), integer()}) :: [{integer(), integer()}]
    def get_sides({x, y}), do: [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]

    @spec prepare_loop(output(), (portal(), point() -> point())) :: integer()
    def prepare_loop({map, start}, callback) do
      %{map: map, states: get_states(map, [start]), callback: callback, visited: Map.new()}
      |> Stream.iterate(&get_next/1)
      |> Stream.map(& &1.states)
      |> Enum.find_index(&reached?/1)
    end

    defp get_next(state) do
      next =
        state.states
        |> Enum.map(fn
          {position, :free} -> position
          {position, {:portal, portal}} -> state.callback.(portal, position)
        end)
        |> Enum.reject(&(is_nil(&1) or Map.has_key?(state.visited, &1)))
        |> Enum.uniq()

      state
      |> Map.update!(:visited, fn old_value ->
        state.states
        |> Map.new(fn {key, _} -> {key, :visited} end)
        |> Map.merge(old_value)
      end)
      |> Map.put(:states, get_states(state.map, next))
    end

    defp get_states(map, positions) do
      positions
      |> Enum.flat_map(fn position ->
        position.position
        |> get_sides()
        |> Enum.map(&%{position | position: &1})
      end)
      |> Enum.map(&{&1, Map.get(map, &1.position)})
      |> Enum.reject(&is_nil(elem(&1, 1)))
      |> Map.new()
    end

    defp reached?(objects),
      do:
        Enum.any?(objects, fn
          {%{level: 0}, {:portal, %{name: name}}} -> name === "ZZ"
          _ -> false
        end)
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 20
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.prepare_loop(&transport/2)
    end

    defp transport(%{destination: nil}, _), do: nil
    defp transport(%{destination: destination}, position), do: %{position | position: destination}
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 20
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.prepare_loop(&transport/2)
    end

    defp transport(%{destination: nil}, _), do: nil
    defp transport(%{outer?: false} = portal, position), do: do_transport(portal, position)

    defp transport(portal, %{level: level} = position) when level > 0,
      do: do_transport(portal, position)

    defp transport(_, _), do: nil

    defp do_transport(%{destination: destination, outer?: outer?}, %{level: level} = position) do
      new_level = set_level(outer?, level)
      %{position | position: destination, level: new_level}
    end

    defp set_level(true, level), do: level - 1
    defp set_level(false, level), do: level + 1
  end
end
