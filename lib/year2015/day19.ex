defmodule Aletopelta.Year2015.Day19 do
  @moduledoc """
  Day 19 of Year 2015
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 19
    """

    @type input() :: list(binary())
    @type output() :: integer()

    @spec parse_input(input()) :: {%{binary() => list(binary())}, list(binary())}
    def parse_input(input) do
      Enum.reduce(input, {Map.new(), :start}, fn
        "", {map, :start} ->
          {map, :molecule}

        line, {map, :start} ->
          [source | replace] =
            ~r"e|[A-Z][a-z]*"
            |> Regex.scan(line)
            |> Enum.flat_map(& &1)

          {Map.update(map, source, [replace], &[replace | &1]), :start}

        line, {map, _} ->
          replace =
            ~r"[A-Z][a-z]*"
            |> Regex.scan(line)
            |> Enum.flat_map(& &1)

          {map, replace}
      end)
    end
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 19
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> do_loop()
      |> Enum.uniq()
      |> Enum.count()
    end

    defp do_loop({map, replace}), do: do_loop(map, replace, [])

    defp do_loop(_, [], _), do: []

    defp do_loop(map, [molecule | replace], actual) do
      case Map.get(map, molecule, nil) do
        nil ->
          do_loop(map, replace, [molecule | actual])

        list ->
          new_list =
            Enum.map(list, fn molecule ->
              Enum.reverse(actual) ++ molecule ++ replace
            end)

          new_list ++ do_loop(map, replace, [molecule | actual])
      end
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 19
    """
    @spec execute(Common.input(), []) :: Common.output()
    def execute(input, _) do
      input
      |> Common.parse_input()
      |> reverse_map()
      |> do_loop()
      |> Enum.find_index(&(&1 === ["e"]))
    end

    defp reverse_map({map, medecine}), do: {reverse_map(map), medecine}

    defp reverse_map(map),
      do:
        map
        |> Enum.flat_map(fn {key, values} -> Enum.map(values, &{&1, key}) end)
        |> Enum.group_by(&elem(&1, 0), &elem(&1, 1))

    defp do_loop({map, medicine}), do: do_loop(map, Enum.reverse(medicine))
    defp do_loop(map, medecine), do: Stream.iterate(medecine, &iterate(&1, map))

    defp iterate(["Ar" | rest] = medecine, map) do
      case build_rn(medecine) do
        nil ->
          ["Ar" | iterate(rest, map)]

        {rn, rn_rest} ->
          case Map.fetch(map, rn) do
            {:ok, [molecule]} -> [molecule | rn_rest]
            :error -> ["Ar" | iterate(rest, map)]
          end
      end
    end

    defp iterate([first, second | medecine], map) do
      case Map.fetch(map, [second, first]) do
        :error -> [first | iterate([second | medecine], map)]
        {:ok, [molecule]} -> [molecule | medecine]
      end
    end

    defp build_rn(["Rn", atom | medecine], molecule), do: {[atom, "Rn" | molecule], medecine}
    defp build_rn(["Ar" | _], _), do: nil
    defp build_rn([atom | medecine], molecule), do: build_rn(medecine, [atom | molecule])
    defp build_rn(["Ar" | medecine]), do: build_rn(medecine, ["Ar"])
  end
end
