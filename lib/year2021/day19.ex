defmodule Aletopelta.Year2021.Day19 do
  @moduledoc """
  Day 19 of Year 2021
  """
  defmodule Common do
    @moduledoc """
    Common part for Day 19
    """

    @type input() :: [binary()]
    @type scanner() :: %{
            id: integer(),
            positions: [{integer(), integer(), integer()}],
            fingerprint: MapSet.t(),
            position: {integer(), integer(), integer()}
          }
    @type output() :: [scanner()]

    @spec parse_input(input()) :: output()
    def parse_input(input) do
      input
      |> Enum.chunk_by(&(&1 == ""))
      |> Enum.reject(&(&1 == [""]))
      |> Enum.map(&parse_line/1)
    end

    defp parse_line([scanner | positions]) do
      [scanner_id] =
        ~r/\d+/
        |> Regex.scan(scanner)
        |> Enum.map(fn [number] -> String.to_integer(number) end)

      new_positions =
        Enum.map(positions, fn line ->
          [x, y, z] =
            line
            |> String.split(",")
            |> Enum.map(&String.to_integer/1)

          {x, y, z}
        end)

      precompute_fingerprint(%{
        id: scanner_id,
        positions: new_positions,
        fingerprint: MapSet.new(),
        position: {0, 0, 0}
      })
    end

    defp precompute_fingerprint(%{positions: positions} = scanner) do
      fingerprint =
        positions
        |> Enum.with_index()
        |> Enum.flat_map(fn {p1, i} ->
          positions
          |> Enum.drop(i + 1)
          |> Enum.map(fn p2 -> distance_squared(p1, p2) end)
        end)
        |> MapSet.new()

      %{scanner | fingerprint: fingerprint}
    end

    defp distance_squared({x1, y1, z1}, {x2, y2, z2}) do
      dx = x2 - x1
      dy = y2 - y1
      dz = z2 - z1
      dx * dx + dy * dy + dz * dz
    end

    @spec combine(list(), integer()) :: list(list())
    def combine(_, 0), do: [[]]
    def combine([], _), do: []

    def combine([head | tail], size) do
      prefix =
        for next <- combine(tail, size - 1) do
          [head | next]
        end

      prefix ++ combine(tail, size)
    end

    @spec find_overlap(output()) :: {scanner(), output()}
    def find_overlap([first_scanner | remaining_scanners]) do
      process_scanners(first_scanner, remaining_scanners, [first_scanner])
    end

    defp process_scanners(merged_scanner, [], found_scanners) do
      {merged_scanner, found_scanners}
    end

    defp process_scanners(merged_scanner, remaining_scanners, found_scanners) do
      case find_matching(merged_scanner, remaining_scanners) do
        {matched_scanner, rotation_idx, translation, remaining} ->
          merge_positions(
            matched_scanner,
            rotation_idx,
            translation,
            merged_scanner,
            remaining,
            found_scanners
          )

        nil ->
          case try_unmatched(merged_scanner, remaining_scanners, found_scanners) do
            {final_scanner, final_found} -> {final_scanner, final_found}
          end
      end
    end

    defp try_unmatched(merged_scanner, remaining_scanners, found_scanners) do
      case find_indirect(found_scanners, remaining_scanners) do
        {_, matched_scanner, rotation_idx, translation, remaining} ->
          merge_positions(
            matched_scanner,
            rotation_idx,
            translation,
            merged_scanner,
            remaining,
            found_scanners
          )

        nil ->
          {merged_scanner, found_scanners}
      end
    end

    defp merge_positions(
           matched_scanner,
           rotation_idx,
           translation,
           merged_scanner,
           remaining,
           found_scanners
         ) do
      transformed_positions =
        Enum.map(matched_scanner.positions, fn point ->
          point
          |> rotate_point(rotation_idx)
          |> translate_point(translation)
        end)

      new_positions =
        (transformed_positions ++ merged_scanner.positions)
        |> MapSet.new()
        |> MapSet.to_list()

      new_merged_scanner = precompute_fingerprint(%{merged_scanner | positions: new_positions})

      positioned_scanner = %{matched_scanner | position: translation}

      process_scanners(new_merged_scanner, remaining, [positioned_scanner | found_scanners])
    end

    defp find_indirect(found_scanners, remaining_scanners) do
      Enum.reduce_while(found_scanners, nil, fn connecting_scanner, _ ->
        case find_matching(connecting_scanner, remaining_scanners) do
          {matched_scanner, rotation_idx, translation, remaining} ->
            {:halt, {connecting_scanner, matched_scanner, rotation_idx, translation, remaining}}

          nil ->
            {:cont, nil}
        end
      end)
    end

    defp find_matching(reference_scanner, candidate_scanners) do
      ref_fingerprint = reference_scanner.fingerprint
      ref_positions = reference_scanner.positions
      ref_set = MapSet.new(ref_positions)

      Enum.reduce_while(candidate_scanners, nil, fn candidate, _ ->
        if overlap?(ref_fingerprint, candidate.fingerprint) do
          handle_find(
            find_transformation(ref_set, ref_positions, candidate.positions),
            {candidate_scanners, candidate}
          )
        else
          {:cont, nil}
        end
      end)
    end

    defp handle_find({rotation_idx, translation}, {candidate_scanners, candidate}) do
      remaining = Enum.reject(candidate_scanners, &(&1 == candidate))

      {:halt, {candidate, rotation_idx, translation, remaining}}
    end

    defp handle_find(nil, _) do
      {:cont, nil}
    end

    defp overlap?(ref_fingerprint, candidate_fingerprint) do
      intersection_size =
        ref_fingerprint
        |> MapSet.intersection(candidate_fingerprint)
        |> MapSet.size()

      intersection_size > 59
    end

    defp find_transformation(ref_set, ref_positions, candidate_positions) do
      Enum.reduce_while(1..48, nil, fn rotation_idx, _ ->
        rotated_positions = Enum.map(candidate_positions, &rotate_point(&1, rotation_idx))

        case find_translation(ref_set, ref_positions, rotated_positions) do
          nil -> {:cont, nil}
          translation -> {:halt, {rotation_idx, translation}}
        end
      end)
    end

    defp find_translation(ref_set, ref_positions, rotated_positions) do
      Enum.reduce_while(ref_positions, nil, fn {refx, refy, refz}, _ ->
        Enum.reduce_while(rotated_positions, nil, fn {rotx, roty, rotz}, _ ->
          translation = {
            refx - rotx,
            refy - roty,
            refz - rotz
          }

          rotated_positions
          |> Enum.map(&translate_point(&1, translation))
          |> Enum.count(&MapSet.member?(ref_set, &1))
          |> handle_overlap(translation)
        end)
      end)
    end

    defp handle_overlap(count, translation) when count > 11, do: {:halt, {:halt, translation}}
    defp handle_overlap(_, _), do: {:cont, {:cont, nil}}

    defp translate_point({x, y, z}, {tx, ty, tz}) do
      {x + tx, y + ty, z + tz}
    end

    defp rotate_point({x, y, z}, 1), do: {x, y, z}
    defp rotate_point({x, y, z}, 2), do: {y, x, z}
    defp rotate_point({x, y, z}, 3), do: {x, z, y}
    defp rotate_point({x, y, z}, 4), do: {z, x, y}
    defp rotate_point({x, y, z}, 5), do: {y, z, x}
    defp rotate_point({x, y, z}, 6), do: {z, y, x}
    defp rotate_point({x, y, z}, 7), do: {-x, y, z}
    defp rotate_point({x, y, z}, 8), do: {y, -x, z}
    defp rotate_point({x, y, z}, 9), do: {-x, z, y}
    defp rotate_point({x, y, z}, 10), do: {z, -x, y}
    defp rotate_point({x, y, z}, 11), do: {y, z, -x}
    defp rotate_point({x, y, z}, 12), do: {z, y, -x}
    defp rotate_point({x, y, z}, 13), do: {x, -y, z}
    defp rotate_point({x, y, z}, 14), do: {-y, x, z}
    defp rotate_point({x, y, z}, 15), do: {x, z, -y}
    defp rotate_point({x, y, z}, 16), do: {z, x, -y}
    defp rotate_point({x, y, z}, 17), do: {-y, z, x}
    defp rotate_point({x, y, z}, 18), do: {z, -y, x}
    defp rotate_point({x, y, z}, 19), do: {x, y, -z}
    defp rotate_point({x, y, z}, 20), do: {y, x, -z}
    defp rotate_point({x, y, z}, 21), do: {x, -z, y}
    defp rotate_point({x, y, z}, 22), do: {-z, x, y}
    defp rotate_point({x, y, z}, 23), do: {y, -z, x}
    defp rotate_point({x, y, z}, 24), do: {-z, y, x}
    defp rotate_point({x, y, z}, 25), do: {-x, -y, z}
    defp rotate_point({x, y, z}, 26), do: {-y, -x, z}
    defp rotate_point({x, y, z}, 27), do: {-x, z, -y}
    defp rotate_point({x, y, z}, 28), do: {z, -x, -y}
    defp rotate_point({x, y, z}, 29), do: {-y, z, -x}
    defp rotate_point({x, y, z}, 30), do: {z, -y, -x}
    defp rotate_point({x, y, z}, 31), do: {-x, y, -z}
    defp rotate_point({x, y, z}, 32), do: {y, -x, -z}
    defp rotate_point({x, y, z}, 33), do: {-x, -z, y}
    defp rotate_point({x, y, z}, 34), do: {-z, -x, y}
    defp rotate_point({x, y, z}, 35), do: {y, -z, -x}
    defp rotate_point({x, y, z}, 36), do: {-z, y, -x}
    defp rotate_point({x, y, z}, 37), do: {x, -y, -z}
    defp rotate_point({x, y, z}, 38), do: {-y, x, -z}
    defp rotate_point({x, y, z}, 39), do: {x, -z, -y}
    defp rotate_point({x, y, z}, 40), do: {-z, x, -y}
    defp rotate_point({x, y, z}, 41), do: {-y, -z, x}
    defp rotate_point({x, y, z}, 42), do: {-z, -y, x}
    defp rotate_point({x, y, z}, 43), do: {-x, -y, -z}
    defp rotate_point({x, y, z}, 44), do: {-y, -x, -z}
    defp rotate_point({x, y, z}, 45), do: {-x, -z, -y}
    defp rotate_point({x, y, z}, 46), do: {-z, -x, -y}
    defp rotate_point({x, y, z}, 47), do: {-y, -z, -x}
    defp rotate_point({x, y, z}, 48), do: {-z, -y, -x}
  end

  defmodule Part1 do
    @moduledoc """
    Part 1 of Day 19
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.find_overlap()
      |> count_beacons()
    end

    defp count_beacons({%{positions: ps}, _}) do
      Enum.count(ps)
    end
  end

  defmodule Part2 do
    @moduledoc """
    Part 2 of Day 19
    """
    @spec execute(Common.input(), []) :: integer()
    def execute(input, []) do
      input
      |> Common.parse_input()
      |> Common.find_overlap()
      |> find_largest()
    end

    defp find_largest({_, scanners}) do
      scanners
      |> Enum.map(fn %{position: position} -> position end)
      |> Common.combine(2)
      |> Enum.map(&manhattan/1)
      |> Enum.max()
    end

    defp manhattan([{x1, y1, z1}, {x2, y2, z2}]) do
      abs(x1 - x2) + abs(y1 - y2) + abs(z1 - z2)
    end
  end
end
