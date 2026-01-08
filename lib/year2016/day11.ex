defmodule Aletopelta.Year2016.Day11 do
  @moduledoc """
  Day 11 of Year 2016
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 11
    """

    @type input() :: list(binary())
    @type output() :: integer()
    @type generator() :: {:generator, atom()}
    @type microchip() :: {:microchip, atom()}
    @type floors() :: %{integer() => {list(generator()), list(microchip())}}

    @spec parse_input(input()) :: floors()
    def parse_input(input) do
      input
      |> Enum.with_index(fn line, index ->
        generators =
          ~r"([a-z]+)(?: g)"
          |> Regex.scan(line)
          |> Enum.map(fn [_, line] ->
            {:generator, Enum.at(~w"#{line}"a, 0)}
          end)

        microchips =
          ~r"([a-z]+)(?:-)"
          |> Regex.scan(line)
          |> Enum.map(fn [_, line] ->
            {:microchip, Enum.at(~w"#{line}"a, 0)}
          end)

        {index + 1, {generators, microchips}}
      end)
      |> Map.new()
    end

    @spec start_loop(floors()) :: output()
    def start_loop(floors), do: search({1, floors})

    defp generate_combinations({part1, part2}, count),
      do: generate_combinations(part1 ++ part2, count)

    defp generate_combinations(list, count) do
      for length <- 1..count,
          combination <- combinations(list, length),
          do: combination
    end

    defp combinations(_, 0), do: [[]]
    defp combinations([], _), do: []

    defp combinations([head | tail], length) do
      include = for t <- combinations(tail, length - 1), do: [head | t]

      include ++ combinations(tail, length)
    end

    defp search(node), do: search([node], [], Map.new(), 0)
    defp search([], [], _, steps), do: steps

    defp search([], list, visited, steps),
      do:
        list
        |> Enum.uniq_by(&normalize/1)
        |> Enum.reject(&visited?(&1, visited))
        |> search([], visited, steps + 1)

    defp search([node | rest], list, visited, steps) do
      case check(node, visited) do
        :final ->
          steps

        :visited ->
          search(rest, list, visited, steps)

        :new ->
          new_list = next(node) ++ list
          new_visited = Map.put(visited, normalize(node), 1)

          search(rest, new_list, new_visited, steps)
      end
    end

    defp next({elevator, floors}) do
      original = process_original(elevator, floors)

      elevator
      |> next_position()
      |> Enum.flat_map(&process_floor(&1, floors, original))
      |> Enum.map(fn {new_elevator, source, target} ->
        new_floors =
          floors
          |> Map.update!(elevator, fn _ -> source end)
          |> Map.update!(new_elevator, fn _ -> target end)

        {new_elevator, new_floors}
      end)
      |> Enum.uniq_by(&normalize/1)
    end

    defp process_original(elevator, floors) do
      {original_generators, original_microchips} = Map.fetch!(floors, elevator)

      (original_generators ++ original_microchips)
      |> generate_combinations(2)
      |> Enum.map(fn combination ->
        {generators, microchips} =
          objects = Enum.split_with(combination, &(elem(&1, 0) === :generator))

        {{original_generators -- generators, original_microchips -- microchips}, objects}
      end)
      |> Enum.filter(fn {objects, _} -> valid?(objects) end)
      |> Enum.uniq_by(fn {{generators, microchips}, _} ->
        {length(generators), length(microchips)}
      end)
    end

    defp process_floor(elevator, floors, original) do
      {floor_generators, floor_microchips} = Map.fetch!(floors, elevator)

      original
      |> Enum.map(fn {source, {generators, microchips}} ->
        {elevator, source, {floor_generators ++ generators, floor_microchips ++ microchips}}
      end)
      |> Enum.filter(fn {_, _, objects} -> valid?(objects) end)
      |> Enum.uniq_by(fn {_, _, {generators, microchips}} ->
        {length(generators), length(microchips)}
      end)
    end

    defp valid?(objects) do
      {single, many} = split_pairs(objects)

      info =
        single
        |> Enum.flat_map(&elem(&1, 1))
        |> Enum.uniq_by(& &1)
        |> Enum.sort(:desc)

      not ((Enum.at(info, 0) === :microchip and not Enum.empty?(many)) or
             (Enum.at(info, 1) === :generator and Enum.empty?(many)))
    end

    defp split_pairs({generators, microchips}),
      do:
        (generators ++ microchips)
        |> Enum.group_by(&elem(&1, 1), &elem(&1, 0))
        |> Enum.split_with(&(length(elem(&1, 1)) < 2))

    defp next_position(1), do: [2]
    defp next_position(4), do: [3]
    defp next_position(elevator), do: [elevator - 1, elevator + 1]

    defp normalize({elevator, old_floors}) do
      floors =
        old_floors
        |> Enum.map(fn {key, {generators, microchips}} ->
          {key, length(generators), length(microchips)}
        end)
        |> Enum.sort()

      {elevator, floors}
    end

    defp check(_, visited) when map_size(visited) < 1, do: :new

    defp check(node, visited) when is_map(visited) do
      if visited?(node, visited) and 1 > 0 do
        :visited
      else
        check(node, nil)
      end
    end

    defp check({_, node}, nil) do
      state =
        1..3
        |> Enum.map(&Map.fetch!(node, &1))
        |> Enum.all?(fn {generators, microchips} ->
          Enum.all?([generators, microchips], &Enum.empty?/1)
        end)

      if state, do: :final, else: :new
    end

    defp visited?(node, visited), do: is_map_key(visited, normalize(node))
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 11
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> Common.start_loop()
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 11
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> update()
      |> Common.start_loop()
    end

    defp update(floors),
      do:
        Map.update!(floors, 1, fn {generators, microchips} ->
          {[{:generator, :elerium}, {:generator, :dilithium} | generators],
           [{:microchip, :elerium}, {:microchip, :dilithium} | microchips]}
        end)
  end
end
